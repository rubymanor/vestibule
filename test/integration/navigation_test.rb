require 'test_helper'

class NavigationTest < IntegrationTestCase
  
  context "When not logged in" do
    should "be sent to proposal list when visiting the root url" do
      visit "/"
      assert_equal proposals_path, page.current_path
    end
  end

  context "When logged in" do
    setup do
      sign_in FactoryGirl.create(:user)
    end

    should "be sent to your dashboard when logged in" do
      visit "/"
      assert_equal dashboard_path, page.current_path
    end
  end
  
end