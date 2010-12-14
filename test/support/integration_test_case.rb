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
  end

  Dir["#{Rails.root}/test/support/integration_steps/*.rb"].each do |hotfix|
    load hotfix
    include const_get(File.basename(hotfix).gsub(/\.rb$/,'').camelcase)
  end

  class << self
    alias :scenario :should
  end
end

Shoulda::Context.class_eval do
  alias :scenario :should
end