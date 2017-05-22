class Product < ApplicationRecord
  include Product::Scopes
  GOOD_DISCOUNT = 30
  GOOD_RATING = 3.5
  GOOD_RATINGS_COUNT = 0
  PROMOTIONS_CACHE_KEY = "PROMOTIONS_CACHE_KEY"

  belongs_to :user
  has_many :discounts
  validates :name, :description, :base_price, :currency, :current_price, :user, :icon_url, :big_icon_url, presence: true

  validates :base_price, :current_price, numericality: true
  validates :store_id, uniqueness: { scope: :user_id }

  before_save :set_discount_ratio

  def self.counts
    User.all.map(&:products).map(&:count)
  end

  def is_free?
    base_price == 0.0
  end

  def is_discounted?
    base_price > current_price
  end

  def is_good_quality?
    average_user_rating >= Product::GOOD_RATING && user_rating_count >= Product::GOOD_RATINGS_COUNT
  end

  def is_us_product?
    store_country == 'us'
  end

  private

  def discount_ratio_value
    return 0 unless is_discounted?
    return 100 if base_price.to_f == 0.0

    diff = base_price.to_f - current_price.to_f

    return 100 if diff == 0.0

    ((diff / base_price) * 100).round(0).to_i
  end

  def set_discount_ratio
    self.discount_ratio = discount_ratio_value
  end
end
