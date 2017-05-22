class Product::UrlParser < SmartInit::Base
  initialize_with :raw_url
  is_callable

  def call
    elements = raw_url.split("/")

    {
      store_country: elements.fetch(3),
      store_id: elements.last.split("?").first.remove("id")
    }
  end
end
