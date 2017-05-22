require 'open-uri'

class SitemapController < ApplicationController
  def show
    data = open(URI.parse("https://s3-us-west-1.amazonaws.com/smart-wishlist/sitemaps/sitemap.xml"))
    send_data data.read, type: 'text/xml', disposition: 'inline'
  end
end
