require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  get 'sitemap.xml', to: "sitemap#show"
  mount PgHero::Engine, at: "pghero"

  if Rails.env.development? || Rails.env.test?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  ActiveAdmin.routes(self)
  root to: 'static_pages#home'
  resources :discounts, only: [:index, :show], param: :slug

  namespace :api do
    resources :products, only: [:index, :create] do
      delete :destroy, on: :collection
    end

    resources :promotions, only: [:index]
    resources :users, only: [:create] do
      put :update, on: :collection
    end
  end

  if Rails.env.production? || Rails.env.staging?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch("ADMIN_LOGIN"))) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch("ADMIN_PASSWORD")))
    end
  end

  mount Sidekiq::Web, at: "/sidekiq"
end

