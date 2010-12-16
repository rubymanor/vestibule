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

    # You'd get this by including Warden::Test:Helpers, but I don't want
    # the other methods it provides.
    ::Warden::test_mode!
    # NOTE: The following 2 lines are the contents of the Warden::Test::Helpers#logout
    # method. I don't want it polluting my namespace though, so I've copied it manually.
    # Tell warden to clear up any old logins at the start of the test
    # EVEN THOUGH you'd think that's what test_reset! might do.
    ::Warden.on_next_request do |proxy|
      proxy.logout
    end
  end

  teardown do
    DatabaseCleaner.clean
    Warden.test_reset!
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