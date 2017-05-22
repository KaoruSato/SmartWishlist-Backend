class API::ProductsController < API::BaseController
  before_action :authenticate!

  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      status: "not_found"
    }, status: 404
  end

  def create
    Product::Maker.run(
      current_user.id,
      params.fetch(:app_url)
    )

    render json: {
      status: "created"
    }, status: 201
  end

  def index
    products_json = current_user.products.by_newest.map do |product|
      Product::Serializer.new(product).to_json
    end

    render json: { products: products_json }
  end

  def destroy
    current_user.products.find_by!(
      store_id: params.fetch(:store_id)
    ).destroy!

    render json: { status: "destroyed" }
  end
end
