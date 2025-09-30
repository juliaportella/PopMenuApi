# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in spec/support/
# and its subdirectories. Files matching `spec/**/*_spec.rb` are run as spec files by default.
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Ensure that the test database schema matches the current schema file
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Include FactoryBot syntax to simplify calls to build/create
  config.include FactoryBot::Syntax::Methods

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.file_fixture_path = Rails.root.join('spec/fixtures/files')

  # Run each example within a transaction
  config.use_transactional_fixtures = true

  # Automatically infer spec type from file location (e.g., models, controllers, requests)
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # Arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

# Shoulda Matchers configuration
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
