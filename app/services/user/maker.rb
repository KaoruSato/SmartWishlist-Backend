class User::Maker < SmartInit::Base
  initialize_with :user_params
  is_callable

  def call
    User.create!(
      auth_token: user_params.fetch(:auth_token),
      device_token: user_params.fetch(:device_token),
      sandbox: user_params.fetch(:sandbox),
      timezone: user_params.fetch(:timezone),
      store_country: user_params.fetch(:store_country),
      last_active: Time.current,
      is_pro: false
    )
  end
end
