source 'https://rubygems.org'
ruby '2.6.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'mime-types', '>= 2.6', require: 'mime/types/columnar'
gem 'rails', '~> 5.1.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'smart_init', '~> 1.1.0'
gem 'slack-notifier', "~> 2.1.0"
gem 'slim', '~> 3.0.8'
gem 'activeadmin', '~> 1.0.0'
gem 'exception_notification', '~> 4.2.1'
gem 'grackle'
gem 'faraday'
gem 'sidekiq', '~> 4.2.10'
gem 'sidekiq-cron', "~> 0.4.0"
gem 'rpush', '~> 2.7.0'
gem 'sprockets-es6'
gem 'webpacker', git: 'https://github.com/pawurb/webpacker.git'
gem 'react-rails'
gem 'rack-cors', require: 'rack/cors'
gem "jquery-rails"
gem "jquery-slick-rails"
gem 'bootstrap-sass', '~> 3.3.7'
gem 'sass-rails', '>= 3.2'
gem 'koala', "~> 3.0.0"
gem 'yajl-ruby', require: 'yajl/json_gem'
gem 'sitemap_generator'
gem 'fog-aws'
gem 'pghero'
gem 'redis'
gem 'activerecord-analyze'
gem 'tzinfo-data'

group :development, :test do
  gem 'rswag', '~> 1.3.0'
  gem 'byebug'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'derailed_benchmarks'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'vcr'
  gem 'webmock'
  gem 'mock_redis'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

