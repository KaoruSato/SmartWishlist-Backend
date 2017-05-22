class Product::DiscountChecker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def initialize(api_client = Product::ApiClient.build)
    @api_client = api_client
  end

  def perform(product_id)
    find_product!(product_id)
    find_user!(product.user_id)

    data = api_client.get_data(
      store_id: product.store_id,
      store_country: user.store_country
    )

    if data[:currency] != product.currency
      return unless Rails.env.test?
    end

    if discount_present?(data)
      product.update!(
        current_price: data.fetch(:current_price),
        lowest_price: data.fetch(:current_price),
        current_price_formatted: data.fetch(:current_price_formatted)
      )

      should_publish = Discount::ShouldPublish.call(product)

      discount = product.discounts.create!(
        store_id: product.store_id,
        from_price: product.base_price,
        to_price: product.current_price,
        was_tweeted: should_publish
      )

      discount.update_usd_prices

      if should_publish
        TwitterBotJob.perform_async(
          Product::TwitterText.call(product)
        )
      end

      User::DiscountNotifier.call(product)
    elsif current_price_changed?(data)
      product.update!(
        current_price: data.fetch(:current_price),
        current_price_formatted: data.fetch(:current_price_formatted),
      )
    end

    if (rating = data.fetch(:average_user_rating)) != 0
      product.update!(
        average_user_rating: rating,
        user_rating_count: data.fetch(:user_rating_count)
      )
    end
  rescue API::NotFoundByStoreId
    product.destroy!
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end

  private

  def discount_present?(data)
    current_price = data.fetch(:current_price).to_f
    current_price < product.current_price.to_f && current_price < product.base_price.to_f && current_price < product.lowest_price.to_f
  end

  def current_price_changed?(data)
    data.fetch(:current_price).to_f != product.current_price.to_f
  end

  def find_product!(product_id)
    @product = Product.find(product_id)
  end

  def find_user!(user_id)
    @user = User.find(user_id)
  end

  attr_reader :product, :user, :api_client
end
