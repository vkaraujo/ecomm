require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start 'rails' do
    add_filter '/bin/'
    add_filter '/db/'
    add_filter '/spec/'
    add_filter '/config/'
    add_filter '/vendor/'
    add_filter '/mailers/application_mailer.rb'
    add_filter '/jobs/application_job.rb'
    add_filter '/channels/application_cable/connection.rb'
    add_filter '/channels/application_cable/channel.rb'

    add_group "Models", "app/models"
    add_group "Controllers", "app/controllers"
    add_group "Mailers", "app/mailers"
    add_group "Jobs", "app/jobs"
    add_group "Services", "app/services"
    add_group "Helpers", "app/helpers"

    track_files "app/**/*.rb"
  end
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FactoryBot::Syntax::Methods
end

# Configure Shoulda Matchers to use RSpec as the test framework
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
