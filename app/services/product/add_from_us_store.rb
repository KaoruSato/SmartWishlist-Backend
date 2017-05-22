class Product::AddFromUSStore < SmartInit::Base
  initialize_with :product
  is_callable

  def call
    return if product.is_us_product?
    return if product.base_price == 0.0
    Product::Maker.new.perform(
      User.system_user.id,
      americanized_store_url(product)
    )
  end

  private

  def americanized_store_url(product)
    product.app_url.sub "/#{product.store_country}/", "/us/"
  end
end
