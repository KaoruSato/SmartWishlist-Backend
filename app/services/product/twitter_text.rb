class Product::TwitterText < Product::BotTextBase
  def call
%Q(#DISCOUNT -#{product.discount_ratio}% \"#{product.name}\" from #{product.base_price_formatted} to #{product.current_price_formatted}

#{hashtags}

#{share_link(product.store_id)})
  end

  private

  def campaign_token
    "b"
  end
end
