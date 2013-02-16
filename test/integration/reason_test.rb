require 'test_helper'

class ReasonTest < IntegrationTestCase
  context "When signing in after registering without having supplied a reason" do
    setup do
      Settings['event_name'] = 'Event name'
      @user = FactoryGirl.create(:user, :signup_reason => nil)
      sign_in @user
    end

    should "tell the user that they haven't stated a reason for siging up" do
      assert has_content?("Other attendees are wondering what you hope to get out of Event name.")
    end

    context "be able to provide a reason now" do
      setup do
        click_link "Tell them now"
      end

      should %Q{not show the "you haven't added a reason" message} do
        assert !has_content?("Other attendees are wondering what you hope to get out of Event name.")
      end

      context "be able to provide their sign up reason" do
        setup do
          fill_in "user_signup_reason", :with => "I have signed up because I want to help shape the content"
          click_button "Save"
        end

        should "show new sign up reason" do
          assert has_css?("#signup_reason", :text => "I have signed up because I want to help shape the content")
        end
      end

      context "be able to provide their sign up reason and preserve markdown syntax" do
        setup do
          fill_in "user_signup_reason", :with => %{
## Me

I like hacking on non-rails ruby stuff

## Why I've signed up

I want to make sure that the talks cover something *other* than rails!!
}
          click_button "Save"
        end

        should "show new sign up reason" do
          within("#signup_reason") do
            assert page.has_css?('h2', :text => "Me")
            assert page.has_css?('p', :text => 'I like hacking on non-rails ruby stuff')
            assert page.has_css?('h2', :text => "Why I've signed up")
            assert page.has_css?('p', :text => 'I want to make sure that the talks cover something other than rails!!')
          end
        end

        should "allow the user to go back and edit their reason" do
          click_link 'Edit your reason'

          i_am_on edit_user_path(@user)
        end
      end
    end
  end

  context "When signing in after registering when they have supplied a reason" do
    setup do
      user = FactoryGirl.create(:user)
      sign_in user
    end

    should "not tell the user that they haven't stated a reason for siging up" do
      assert !has_content?("Other attendees are wondering what you hope to get out of Event name.")
    end
  end
end
