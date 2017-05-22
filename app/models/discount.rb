class Discount < ApplicationRecord
  MAX_FRESH_AGE = 2.month.ago
  belongs_to :product
  delegate :currency, to: :product, allow_nil: true, prefix: false

  scope :was_tweeted, -> {
    where(was_tweeted: true)
  }

  scope :recent, -> {
     where("discounts.created_at > ?", MAX_FRESH_AGE)
  }

  def self.total_usd_value
    where(id: select("distinct on (product_id) id")).sum(:usd_value).to_f
  end

  def self.uniq_apps_count
    where(id: select("distinct on (store_id) id")).count
  end

  def update_usd_prices
    return unless currency
    return unless currency_object = Currency.find_by(name: currency)
    return unless rate = currency_object.usd_rate

    from_price_usd_val = from_price / rate
    to_price_usd_val = to_price / rate
    update!(
      from_price_usd: from_price_usd_val,
      to_price_usd: to_price_usd_val,
      usd_value: from_price_usd_val - to_price_usd_val
    )
  end

  def value
    (from_price - to_price).to_f.round(2)
  end

  def ratio
    return 100 if from_price.to_f == 0.0

    diff = from_price.to_f - to_price.to_f

    return 100 if diff == 0.0

    ((diff / from_price) * 100).round(0).to_i
  end
end
