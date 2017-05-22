class Product::StaleDiscountedUpdater
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def initialize(api_client = Product::ApiClient.build)
    @api_client = api_client
  end

  def perform(product_id)
    find_product!(product_id)

    data = api_client.get_data(
      store_id: product.store_id,
      store_country: product.store_country
    )

    if price_did_increase?(data)
      product.update!(
        current_price: data.fetch(:current_price),
        current_price_formatted: data.fetch(:current_price_formatted),
      )
    end
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end

  private

  def price_did_increase?(data)
    data.fetch(:current_price).to_f > product.current_price.to_f
  end

  def find_product!(product_id)
    @product = Product.find(product_id)
  end

  attr_reader :product, :user, :api_client
end
