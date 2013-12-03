require 'test_helper'

class FeatureHelperTest < ActionView::TestCase
  include FeatureHelper

  context "rendering a switched-on feature" do
    setup do
      Vestibule::Application.config.features.test_feature = true
    end

    should "correctly render the feature" do
      result = feature(:test_feature) { "Hello" }
      assert_equal "hello", result
    end
  end
end
