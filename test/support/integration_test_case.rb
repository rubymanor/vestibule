require 'capybara/rails'
require 'capybara/dsl'

class IntegrationTestCase < ActiveSupport::TestCase
  include Capybara
  include ActionDispatch::Assertions
  include Rails.application.routes.url_helpers
  self.default_url_options[:host] = 'http://example.com/'

  self.use_transactional_fixtures = false

  setup do
    ActionMailer::Base.deliveries.clear
    Capybara.default_selector = :css
    Capybara.save_and_open_page_path = File.join(Rails.root, 'tmp')
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
  OmniAuth.config.mock_auth[:twitter] = {
    "provider"=>"twitter",
    "uid"=>"123456",
    "user_info"=>{"name"=>"Alice", "nickname"=>"a_dawg"}
  }

  def within_object(*args, &block)
    selector = args.map { |a| a.is_a?(String) ? a : "##{ActionController::RecordIdentifier.dom_id(a)}" }.join(" ")
    within(selector, &block)
  end

  class << self
    alias :scenario :should
  end
end

Shoulda::Context.class_eval do
  alias :scenario :should
end