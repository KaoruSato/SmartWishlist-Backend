# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://wishlist.apki.io"

SitemapGenerator::Sitemap.create do
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #

  SitemapGenerator::Sitemap.public_path = 'tmp/'
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
    aws_access_key_id: ENV.fetch("AWS_USER_ID"),
    aws_secret_access_key: ENV.fetch("AWS_USER_SECRET"),
    fog_directory: ENV.fetch("AWS_BUCKET_NAME"),
    fog_region: ENV.fetch("AWS_REGION")
  )
  SitemapGenerator::Sitemap.sitemaps_host = "https://s3-us-west-1.amazonaws.com/"
  SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
  SitemapGenerator::Sitemap.compress = false

  SitemapGenerator::Sitemap.create do
    add '/discounts', priority: 1.0, changefreq: 'daily'
    Product.current_promotions.uniq(&:store_id).each do |pr|
      add discount_path(pr.slug), priority: 0.7, changefreq: 'daily'
    end
  end
end
