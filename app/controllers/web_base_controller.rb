class WebBaseController < ApplicationController
  before_action :set_js_data
  before_action :set_data

  private

  def set_data
    @app_store_link = "https://itunes.apple.com/us/app/smart-wishlist-buy-cheaper-apps-and-save-money/id1239519423?ls=1&mt=8&at=1001lxGu"
    @api_url = "#{request.protocol}#{request.host}:#{request.port}"
    @page_title = "Smart Wishlist - Track the best iOS discounts for free"
    @page_description = "A simple tool to track iOS App Store discounts. You can add apps directly from within the App Store. You will then receive a push notification whenever there’s a price drop for an app that you added. It is a replacement for a built in wish list with a nice bonus feature of helping you save money."
    @page_image = "https://wishlist.apki.io/wishlist-icon.png"
  end

  def set_js_data
    @controller = params.fetch(:controller)
    @action = params.fetch(:action)
    @app_store_button = ActionController::Base.helpers.asset_path("app_store_button.svg")
  end
end
