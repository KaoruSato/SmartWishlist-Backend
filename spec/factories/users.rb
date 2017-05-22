FactoryGirl.define do
  factory :user do
    auth_token { SecureRandom.hex }
    device_token { SecureRandom.hex }
    device_push_token { SecureRandom.hex }
    last_active 1.hour.ago
    store_country { ["GB", "US", "DE"].sample }
    timezone { ["Europe/Berlin", "Asia/Kathmandu"].sample }
    sandbox false
  end
end
