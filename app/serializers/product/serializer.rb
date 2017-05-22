class Product::Serializer < SmartInit::Base
  initialize_with :product

  DESCRIPTION_LIMIT = 140
  PROXY_HOST = "https://proxy.apki.io/"
  private_constant :DESCRIPTION_LIMIT

  def to_json
    {
      id: product.id,
      store_id: product.store_id,
      name: product.name,
      description: product.description,
      base_price: product.base_price,
      current_price: product.current_price,
      base_price_formatted: product.base_price_formatted,
      current_price_formatted: product.current_price_formatted,
      currency: product.currency,
      preview_icon: product.big_icon_url,
      icon_url: proxy_image_url(product.icon_url),
      big_icon_url: proxy_image_url(product.big_icon_url),
      is_discounted: product.is_discounted?,
      discount_ratio: product.discount_ratio,
      is_free: product.is_free?,
      store_url: "https://itunes.apple.com/us/app/id#{product.store_id}?at=#{ENV.fetch('AFFILIATE_TOKEN')}&ct=wl",
      average_user_rating: product.average_user_rating,
      user_rating_count: product.user_rating_count,
      average_user_rating_formatted: format_average_user_rating(product.average_user_rating),
      user_rating_count_formatted: format_user_rating_count(product.user_rating_count),
      slug: product.slug
    }
  end

  private

  def format_user_rating_count(value)
    if value > 999
      ">999"
    else
      value.to_s
    end
  end

  def format_average_user_rating(value)
    sprintf('%.1f', value)
  end

  def proxy_image_url(image_url)
    if image_url.include?("https")
      image_url
    else
      https_version = image_url.sub("http", "https")
      number = first_number(https_version)
      https_version.sub("//is#{number}", "//is#{number}-ssl")
    end
  end

  def first_number(string)
    string[/\d+/].to_i
  end
end
