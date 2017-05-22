class API::UsersController < API::BaseController
  before_action :authenticate,  only: [:create]
  before_action :authenticate!, only: [:update]

  def create
    status, status_code = if current_user
      ["exists", 200]
    else
      user = User::Maker.call(user_maker_params)
      if User.count % 100 == 0
        SlackNotifierJob.perform_async(
          "New user: #{user.timezone} #{user.store_country}, Total: #{User.count}"
        )
      end

      ["created", 201]
    end

    render json: {
      status: status
    }, status: status_code
  end

  def update
    current_user.update!(
      device_push_token: params.fetch(:device_push_token)
    )

    render json: {
      status: "updated"
    }, status: 200
  end

  private

  def user_maker_params
    {
      auth_token: params.fetch(:auth_token),
      device_token: params.fetch(:device_token),
      sandbox: params.fetch(:sandbox),
      timezone: params.fetch(:timezone),
      store_country: params.fetch(:store_country)
    }
  end
end
