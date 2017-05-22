class User < ApplicationRecord
  FREE_LIMIT = 3
  SYSTEM_USER_TOKEN = ENV.fetch('SYSTEM_USER_TOKEN')

  has_many :products
  validates :auth_token, :device_token, :timezone, presence: true

  def has_product?(store_id:)
    products.where(store_id: store_id).exists?
  end

  def is_sleeping?
    timezone_object = ActiveSupport::TimeZone.new(timezone) || ActiveSupport::TimeZone.new("Central Time (US & Canada)")

    hour = timezone_object.now.hour
    hour < 9 || hour > 21
  end

  def self.authenticate(auth_token:, device_token:)
    User.where(
      auth_token: auth_token,
      device_token: device_token
    ).first
  end

  def is_system_user?
    auth_token == SYSTEM_USER_TOKEN && device_token == SYSTEM_USER_TOKEN
  end

  def self.system_user
    User.where(
      auth_token: SYSTEM_USER_TOKEN,
      device_token: SYSTEM_USER_TOKEN
    ).first!
  end
end
