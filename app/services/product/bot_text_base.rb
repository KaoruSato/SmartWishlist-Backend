class Product::BotTextBase < SmartInit::Base
  initialize_with :product
  is_callable

  private

  def discounts_link
    "https://wishlist.apki.io/discounts"
  end

  def share_link(store_id)
    "https://itunes.apple.com/us/app/id#{store_id}?at=#{ENV.fetch("AFFILIATE_TOKEN")}&ct=#{campaign_token}"
  end

  def hashtags
    "#AppStore #iOS"
  end
end
