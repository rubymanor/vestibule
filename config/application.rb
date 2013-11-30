require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Vestibule
  class Application < Rails::Application
    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.assets.version = '1.0'
    # as recommended by heroku (https://devcenter.heroku.com/articles/rails-asset-pipeline#troubleshooting)
    config.assets.initialize_on_precompile = false

    config.middleware.use OmniAuth::Builder do
      provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'user:email'
    end

    def modes
      @modes ||= Modes.new
    end

    # Set modes reload after the finisher hook, because that's what
    # Routes reloading does
    initializer :set_modes_reloader_hook do
      reloader = ModesReloader.new(root.join('config/modes.rb'), modes)
      reloader.execute_if_updated
      self.reloaders << reloader
      ActionDispatch::Reloader.to_prepare do
        # We configure #execute rather than #execute_if_updated because if
        # autoloaded constants are cleared we need to reload modes
        # This is all cribbed from how Routes reloading is done
        # but seems plausible
        reloader.execute
      end
    end

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'vestibule', '*.{rb,yml}')]
  end
end
