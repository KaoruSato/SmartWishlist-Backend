Koala.configure do |config|
  config.app_id = ENV.fetch("FB_APP_ID")
  config.app_secret = ENV.fetch("FB_APP_SECRET")
  config.access_token = ENV.fetch("FB_ACCESS_TOKEN")
end
