class CacheUpdaterJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    products = Product.current_promotions.uniq(&:store_id)
    .map do |product|
      Product::Serializer.new(product).to_json
    end

    json_data = { products: products }.to_json
    $redis.set(
      Product::PROMOTIONS_CACHE_KEY,
      json_data
    )
  end
end
