class Product::ApiClient < SmartInit::Base
  using HashHelpers
  initialize_with :network_provider

  API_HOST = "https://itunes.apple.com".freeze
  private_constant :API_HOST

  def self.build
    new(Faraday.new(API_HOST))
  end

  def get_data(store_id:, store_country: 'US')
    response = network_provider.get('/lookup',
      id: store_id,
      country: store_country,
      entity: 'software'
    )

    store_country = 'US' if store_country == 'app'
    json_data = JSON.parse(response.body)

    handle_error!(json_data.merge(store_country: store_country, store_id: store_id)) unless response.success?

    result = json_data.deep_fetch("results", 0)

    {
      name: result.fetch("trackName"),
      description: result.fetch("description"),
      base_price: result.fetch("price"),
      current_price: result.fetch("price"),
      base_price_formatted: result.fetch("formattedPrice"),
      current_price_formatted: result.fetch("formattedPrice"),
      currency: result.fetch("currency"),
      icon_url: result.fetch("artworkUrl100"),
      big_icon_url: result.fetch("artworkUrl512"),
      average_user_rating: result.fetch("averageUserRating") { 0 },
      user_rating_count: result.fetch("userRatingCount") { 0 }
    }

  rescue IndexError
    raise API::NotFoundByStoreId, json_data
  rescue JSON::ParserError
    raise API::StoreNetworkError, json_data
  end

  private

  def handle_error!(json_data)
    if json_data.fetch("errorMessage").include?("country")
      raise API::CountryStoreNotFound, json_data
    end
    raise API::StoreNetworkError, json_data
  end
end
