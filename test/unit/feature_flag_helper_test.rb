require 'test_helper'

class FeatureFlagHelperTest < ActionView::TestCase
  include FeatureFlagHelper

  context "rendering a switched-on feature" do
    should "correctly render a switched-on feature" do
      Vestibule::Application.config.features.test_feature = true
      result = if_feature(:test_feature) { "Hello" }
      assert_equal "Hello", result
    end

    should "correctly render nothing for a switched-off feature" do
      Vestibule::Application.config.features.test_feature = false
      result = if_feature(:test_feature) { "Hello" }
      assert_equal "", result
    end
  end
end
