class API::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  unless Rails.env.test?
    rescue_from StandardError do |e|
      handle_error("error", 500, e)
    end
  end

  rescue_from KeyError do |e|
    handle_error("invalid_request", 400, e)
  end

  rescue_from API::StoreNetworkError do |e|
    handle_error("itunes_api_error", 502, e)
  end

  rescue_from API::AuthenticationError do |e|
    handle_error("auth_error", 401, e)
  end

  private

  def authenticate
    @current_user ||= User.authenticate(
      auth_token: params.fetch(:auth_token),
      device_token: params.fetch(:device_token)
    )
  end

  def authenticate!
    authenticate || (raise API::AuthenticationError)
  end

  def current_user
    @current_user
  end

  def handle_error(status, http_status, error)
    ExceptionNotifier.notify_exception(error)
    Rails.logger.error error
    render json: {
      status: status
    }, status: http_status
  end
end
