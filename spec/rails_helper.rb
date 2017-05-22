ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'spec_helper'
require 'vcr'
ActiveRecord::Migration.maintain_test_schema!

require 'sidekiq/testing'
Sidekiq::Testing.inline!

module JsonApiHelpers
  def json_response
    @_json_response ||= ActiveSupport::HashWithIndifferentAccess.new(
        JSON.parse(response.body)
      )
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.include JsonApiHelpers, type: :controller
  config.include ActiveSupport::Testing::TimeHelpers

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
end

FG = FactoryGirl

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

