if Rails.env.test? || Rails.env.development?
  require "mocha/version"
  require "mocha/deprecation"
  if Mocha::VERSION == "0.13.1" && Rails::VERSION::STRING == "3.2.11"
    Mocha::Deprecation.mode = :disabled
  end
end
