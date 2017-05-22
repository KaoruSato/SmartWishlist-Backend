FactoryGirl.define do
  factory :currency do
    name { Currency::LIST.sample }
    usd_rate { rand(15.0..20.0).round(2) }
  end
end
