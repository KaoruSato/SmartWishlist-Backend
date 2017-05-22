class DiscountsController < WebBaseController
  before_action :product, only: [:show]

  def index
    respond_to do |format|
      format.html
      format.json do
        redirect_to api_promotions_path
      end
    end
  end

  def show
    raise ActiveRecord::RecordNotFound unless product.fetch(:is_discounted)
    @show_title = "App Store discount #{product.fetch(:discount_ratio)}% off '#{product.fetch(:name)}'"
    @page_title = "#{@show_title} - Smart Wishlist"
    @page_description = "'#{product.fetch(:name)}' is currently discounted from #{product.fetch(:base_price_formatted)} to #{product.fetch(:current_price_formatted)} on iOS App Store."
    @page_image = product.fetch(:preview_icon)
  end

  private

  def product
    @product ||= Product::Serializer.new(Product.find_by!(slug: params.fetch(:slug))).to_json
  end
end
