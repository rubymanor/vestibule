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

  context 'When the app is in archive mode' do
    setup { Vestibule.mode_of_operation = :archive }
    should 'see a notice that the site is in a read-only archive mode' do
      visit '/'
      i_am_alerted('This version of Vestibule is read only. It represents an archive of the community effort to produce content for')
    end
  end
end