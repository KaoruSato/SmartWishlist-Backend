class API::PromotionsController < API::BaseController
  def index
    self.content_type = "application/json"
    self.response_body = [$redis.get(Product::PROMOTIONS_CACHE_KEY) || ""]
  end
end
