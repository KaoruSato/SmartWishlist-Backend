FactoryGirl.define do
  factory :product do
    sequence(:name) { |n|  "product_name_#{n} some more words here" }
    sequence(:slug) { |n|  Product::Maker.generate_slug("product_name_#{n} some more words here" ) }
    sequence(:store_id) { |n|  "store_id_#{n}" }
    base_price { rand(15.0..20.0).round(2) }
    current_price { rand(1.0..8.0).round(2) }

    base_price_formatted { "#{base_price} #{currency}" }
    current_price_formatted { "#{current_price} #{currency}" }
    store_country { %w{ pl en us gb }.sample }
    average_user_rating { rand(3.5..5).round(1) }
    user_rating_count { rand(10..2000).round(1) }

    description { SecureRandom.hex }
    currency { %w{ USD EUR PLN }.sample }
    sequence(:icon_url) { |n| "http://example.com/icon_#{n}.png" }
    sequence(:big_icon_url) { |n| "http://example.com/big_icon_#{n}.png" }
    user
    after(:build) do |product|
      product.lowest_price = product.current_price
    end
  end
end
