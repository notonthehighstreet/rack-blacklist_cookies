require "bundler/setup"
require "rack-blacklist_cookies"
require "rack_setup"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include_context "rack_setup", :include_shared => true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
