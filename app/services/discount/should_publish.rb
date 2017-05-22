class Discount::ShouldPublish < SmartInit::Base
  initialize_with :product
  is_callable
  DISCOUNT_TWEET_OFFSET = 1.day
  MIN_DISCOUNT_RATIO = 30

  def call
    return false if product.discount_ratio < MIN_DISCOUNT_RATIO
    return false unless product.is_us_product?
    return true unless last_tweeted_discount
    return false unless product.is_good_quality?
    last_tweeted_discount.created_at < (Time.current - DISCOUNT_TWEET_OFFSET)
  end

  private

  def last_tweeted_discount
    @_last_tweeted_discount ||= Discount.where(store_id: product.store_id, was_tweeted: true).order(created_at: :desc).first
  end
end
