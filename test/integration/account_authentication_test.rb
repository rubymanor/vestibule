require "test_helper"

class AccountAuthenticationTest < IntegrationTestCase

  context "A registered user signing in" do
    setup do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    should "sign in and tell the user" do
      assert has_content?("Signed in successfully.")
      assert has_css?("#nav a", :text => "Sign out")
    end

    # should "show the user a 50x50 version of their avatar in the main user area" do
    #   within('header .nav') do
    #     i_can_see_the_avatar_for_user(@user)
    #   end
    # end

    should "be able to sign out" do
      visit "/"
      click_link "Sign out"
      assert page.has_css?("#nav", :text => "Sign in")
    end
  end

end
