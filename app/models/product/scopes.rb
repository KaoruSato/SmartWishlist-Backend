module Product::Scopes
  extend ActiveSupport::Concern
  included do
    scope :by_newest, -> {
      order(created_at: :desc)
    }

    scope :currently_discounted, -> {
      where("current_price < base_price")
    }

    scope :currently_discounted_usd, -> {
      currently_discounted.where(store_country: 'us')
    }

    scope :recently_discounted, -> {
      joins(:discounts).merge(Discount.recent).distinct
    }

    scope :discounted_by, -> (value) {
      where('discount_ratio >= ?', value)
    }

    scope :good_quality, -> {
      where(
        "average_user_rating >= ? AND user_rating_count >= ?",
        Product::GOOD_RATING, Product::GOOD_RATINGS_COUNT
      )
    }

    def self.current_promotions
      Product.currently_discounted_usd
      .discounted_by(Product::GOOD_DISCOUNT)
      .recently_discounted
      .good_quality
      .order(discount_ratio: :desc)
    end
  end
end
