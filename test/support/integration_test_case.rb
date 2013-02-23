require 'capybara/rails'
require 'capybara/dsl'

class IntegrationTestCase < ActiveSupport::TestCase
  include Capybara::DSL
  include ActionDispatch::Assertions
  include Rails.application.routes.url_helpers
  self.default_url_options[:host] = 'http://example.com/'

  self.use_transactional_fixtures = false

  setup do
    Vestibule::Application.config.secret_token = '1234567890abcdefabcd1234567890'
    Vestibule.mode_of_operation = :cfp
    ActionMailer::Base.deliveries.clear
    Capybara.default_selector = :css
    Capybara.save_and_open_page_path = File.join(Rails.root, 'tmp')
    Capybara.reset_sessions!
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
    Timecop.return
  end

  Dir["#{Rails.root}/test/support/integration_steps/*.rb"].each do |hotfix|
    load hotfix
    include const_get(File.basename(hotfix).gsub(/\.rb$/,'').camelcase)
  end

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    "provider"=>"github",
    "uid"=>"123456",
    "info"=>{"name"=>"Alice", "nickname"=>"a_dawg", "email" => "alice@example.com"}
  }

  def within_object(*args, &block)
    selector = args.map { |a| a.is_a?(String) ? a : "##{ActionController::RecordIdentifier.dom_id(a)}" }.join(" ")
    within(selector, &block)
  end

  class << self
    alias :scenario :should
  end
end

Shoulda::Context::ClassMethods.class_eval do
  alias :scenario :should
end
