require 'test_helper'

class ControllerFeatureTest < ActionController::TestCase
  should "define a method if a feature is switched on" do
    Vestibule::Application.config.features.test_feature = true

    klass = Class.new(ApplicationController) do
      feature :test_feature do
        def my_method
        end
      end
    end

    assert klass.new.respond_to?(:my_method)
  end

  should "not define a method if a feature is switched off" do
    Vestibule::Application.config.features.test_feature = false

    klass = Class.new(ApplicationController) do
      feature :test_feature do
        def my_method
        end
      end
    end

    refute klass.new.respond_to?(:my_method)
  end
end
