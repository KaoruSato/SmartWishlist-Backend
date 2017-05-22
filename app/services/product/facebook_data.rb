class Product::FacebookData < Product::BotTextBase
  def call
    {
      text: text,
      link_url: share_link(product.store_id)
    }
  end

  private

  def text
%Q(#{discounts_link}

DISCOUNT -#{product.discount_ratio}% \"#{product.name}\" from #{product.base_price_formatted} to #{product.current_price_formatted})
  end

  def campaign_token
    "f"
  end
end

