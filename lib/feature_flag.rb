require 'active_support/concern'

module FeatureFlag
  extend ActiveSupport::Concern

  def if_feature(name, &block)
    if Vestibule::Application.config.features[name]
      instance_exec(&block)
    end
  end

  module ClassMethods
    def if_feature(name, &block)
      if Vestibule::Application.config.features[name]
        class_exec(&block)
      end
    end
  end
end