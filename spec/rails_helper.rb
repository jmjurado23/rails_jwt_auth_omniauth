# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

Dir['spec/factories/**/*.rb'].each { |f| require "./#{f}" }

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = '#{::Rails.root}/spec/fixtures'

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace('gem name')

  #config.include RailsJwtAuth::Spec::Helpers
  config.include ActiveSupport::Testing::TimeHelpers

  config.before(:each) do
    MongoidUser.destroy_all
    ActiveRecordUser.destroy_all
    ActionMailer::Base.deliveries.clear

    RailsJwtAuth.simultaneous_sessions = 1
    RailsJwtAuth.confirm_email_url = 'http://example.com/confirmations'
    RailsJwtAuth.accept_invitation_url = 'http://example.com/invitations'
    RailsJwtAuth.reset_password_url = 'http://example.com/reset_passwords'
    RailsJwtAuth.avoid_email_errors = true

    # Configuration for Lockable module
    RailsJwtAuth.maximum_attempts = 3
    RailsJwtAuth.lock_strategy = :failed_attempts
    RailsJwtAuth.unlock_strategy = :both
    RailsJwtAuth.unlock_in = 60.minutes
    RailsJwtAuth.reset_attempts_in = 60.minutes
    RailsJwtAuth.unlock_account_url = 'http://example.com/unlock-account'
  end
end

def initialize_orm(orm)
  RailsJwtAuth.model_name = "#{orm}User"
end

def get_record_error(record, field)
  return nil unless record && field

  field_error = record.errors&.details[field]&.first
  field_error ? field_error[:error] : nil
end