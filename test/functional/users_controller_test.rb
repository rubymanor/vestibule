require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = Factory(:user)
  end

  context "When logged in" do
    setup do
      session[:user_id] = @user.id
    end

    [:show, :edit].each do |action|
      context "on #GET to #{action.to_s}" do
        setup do
          get action, :id => @user.to_param
        end

        should assign_to(:user) { @user }
        should render_template(action)
      end
    end

    context "on #PUT to update with a signup_reason" do
      setup do
        put :update, :id => @user.to_param, :user => {:signup_reason => "Because I want to learn"}
      end
      should set_the_flash.to("Successfully updated user.")

      should "update the signup reason" do
        assert_equal "Because I want to learn", @user.reload.signup_reason
      end
    end

    context "on #PUT to update for another reason" do
      setup do
        other_user = Factory(:user)
        put :update, :id => other_user.to_param, :user => {:signup_reason => "Haxx'd"}
      end

      should respond_with(:redirect)
      should set_the_flash.to(/You cannot update another user/)
    end
  end

  context "When not logged in" do
    [:show, :edit, :update].each do |action|
      context "on #GET to #{action.to_s}" do
        setup do
          get action, :id => @user.to_param
        end
        should respond_with(:redirect)
        should set_the_flash.to(/You need to sign in/)
      end
    end
  end
end