class Product::Maker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'
  ERRORS_TO_IGNORE = [
    "Validation failed: Store has already been taken"
  ]

  def self.run(user_id, app_url)
    if Rails.env.staging? # save money on heroku...
      new.perform(
        user_id,
        app_url
      )
    else
      perform_async(
        user_id,
        app_url
      )
    end
  end

  def initialize(api_client=Product::ApiClient.build)
    @api_client = api_client
  end

  def perform(user_id, app_url)
    product_data = Product::UrlParser.call(app_url)
    store_id = product_data.fetch(:store_id)
    store_country = product_data.fetch(:store_country)

    product_details = api_client.get_data(
      store_id: store_id,
      store_country: store_country
    )

    new_product = User.find(user_id).products.create!(
      product_details.merge(
        store_id: store_id,
        store_country: store_country,
        app_url: app_url,
        lowest_price: product_details.fetch(:current_price),
        slug: Product::Maker.generate_slug(product_details.fetch(:name))
      )
    )

    Product::AddFromUSStore.call(new_product)
    new_product
  rescue => e
    return if ERRORS_TO_IGNORE.include?(e.message)

    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
  end

  def self.generate_slug(name)
    URI.escape(name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/\-+/, "-")) + "-" + SecureRandom.hex(4)
  end

  private

  attr_reader :api_client, :url_parser
end
