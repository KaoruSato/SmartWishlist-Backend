RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # config.profile_examples = 10

  config.order = :random
  config.expose_dsl_globally = true
  Kernel.srand config.seed

  config.before(:suite) do
    User.delete_all
    FactoryGirl.create(:user,
      auth_token: ENV.fetch("SYSTEM_USER_TOKEN"),
      device_token: ENV.fetch("SYSTEM_USER_TOKEN")
    )
  end

  config.after(:suite) do
    User.delete_all
  end
end
