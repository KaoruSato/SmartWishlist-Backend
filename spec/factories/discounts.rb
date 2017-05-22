FactoryGirl.define do
  factory :discount do
    sequence(:store_id) { |n|  "store_id_#{n}" }
    from_price { rand(15.0..20.0).round(2) }
    to_price { rand(1.0..8.0).round(2) }
    was_tweeted { false }
    product
  end
end
