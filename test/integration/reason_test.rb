require 'test_helper'

class ReasonTest < IntegrationTestCase
  context "When signing in after registering" do
    setup do
      sign_in
    end

    should "tell the user that they haven't stated a reason for siging up" do
      assert has_content?("You haven't provided a reason on why you signed up yet.")
    end

    context "be able to provide a reason now" do
      setup do
        click_link "Provide one now"
      end

      should "not show the you haven't added a reason message" do
        assert !has_content?("You haven't provided a reason on why you signed up yet.")
      end

      context "be able to update the sign up reason" do
        setup do
          fill_in "Signup reason", :with => "I have signed up because I want to help shape the content"
          click_button "Update User"
        end

        should "show new sign up reason" do
          assert has_css?("#signup_reason", :text => "I have signed up because I want to help shape the content")
        end
      end
    end
  end
end