class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  if Rails.env.production?
    newrelic_ignore_enduser
  end

  unless Rails.env.development?
    http_basic_authenticate_with name: ENV.fetch("ADMIN_LOGIN"), password: ENV.fetch("ADMIN_PASSWORD"), if: :admin_controller?
  end

  private

  def admin_controller?
    self.class < ActiveAdmin::BaseController
  end
end
