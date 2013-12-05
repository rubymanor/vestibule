require 'test_helper'
require 'feature'

class FeatureFlagTest < ActiveSupport::TestCase
  should "define a method if a feature is switched on" do
    Vestibule::Application.config.features.test_feature = true

    klass = Class.new do
      include Feature
      feature :test_feature do
        def my_method
        end
      end
    end

    assert klass.new.respond_to?(:my_method)
  end

  should "not define a method if a feature is switched off" do
    Vestibule::Application.config.features.test_feature = false

    klass = Class.new do
      include Feature
      feature :test_feature do
        def my_method
        end
      end
    end

    refute klass.new.respond_to?(:my_method)
  end

  context "within a method" do
    setup do
      @klass = Class.new do
        include Feature
        def my_method
          result = false
          feature :test_feature do
            result = true
          end
          result
        end
      end
    end

    should "execute code if a feature is switched on" do
      Vestibule::Application.config.features.test_feature = true

      assert @klass.new.my_method
    end

    should "not execute code if a feature is switched off" do
      Vestibule::Application.config.features.test_feature = false

      refute @klass.new.my_method
    end
  end
end
