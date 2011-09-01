require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "When logged in" do
    setup do
      @user = Factory(:user)
      session[:user_id] = @user.id
    end

    [:show, :edit].each do |action|
      context "on #GET to #{action.to_s}" do
        setup do
          get action
        end

        should assign_to(:user) { @user }
        should render_template(action)
      end
    end

    context "on #PUT to update with a signup_reason" do
      setup do
        put :update, :user => {:signup_reason => "Because I want to learn"}
      end
      should set_the_flash.to("Successfully updated user.")

      should "update the signup reason" do
        assert_equal "Because I want to learn", @user.reload.signup_reason
      end
    end
  end

  context "When not logged in" do
    [:show, :edit, :update].each do |action|
      context "on #GET to #{action.to_s}" do
        setup do
          get action
        end
        should respond_with(:redirect)
        should set_the_flash.to(/You need to sign in/)
      end
    end
  end
end