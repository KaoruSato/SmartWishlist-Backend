class SitemapUpdater
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    `rake sitemap:refresh:no_ping`
    Faraday.new("http://www.google.com/").get("/webmasters/sitemaps/ping?sitemap=https://wishlist.apki.io/sitemap.xml")
  rescue => e
    ExceptionNotifier.notify_exception(e)
  end
end
