require 'active_support/concern'

module Feature
  extend ActiveSupport::Concern

  module ClassMethods
    def feature(name, &block)
      if Vestibule::Application.config.features[name]
        class_eval(&block)
      end
    end
  end
end
