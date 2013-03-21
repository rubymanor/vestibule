require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:user)
    @other_user = FactoryGirl.create(:user)
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
        should respond_with(:success)
        should render_template(action)
      end
    end

    context "on #PUT to update self" do
      setup do
        put :update, :id => @user.to_param, :user => {:signup_reason => "Because I want to learn"}
      end

      should set_the_flash.to("Successfully updated user.")
      should "update the signup reason" do
        assert_equal "Because I want to learn", @user.reload.signup_reason
      end
      should respond_with(:redirect)
    end

    context 'on #GET to edit for another user' do
      setup do
        get :edit, :id => @other_user.to_param
      end

      should assign_to(:user) { @other_user }
      should respond_with(:redirect)
      should set_the_flash.to(/You are not authorized to access this page/)
    end

    context "on #PUT to update for another user" do
      setup do
        put :update, :id => @other_user.to_param, :user => {:signup_reason => "Haxx'd"}
      end

      should assign_to(:user) { @other_user }
      should respond_with(:redirect)
      should set_the_flash.to(/You are not authorized to access this page/)
      should "not update the signup reason" do
        assert_not_equal "Haxx'd", @other_user.reload.signup_reason
      end
    end
  end

  context "When not logged in" do
    [:show].each do |action|
      context "on #GET to #{action.to_s}" do
        setup do
          get action, :id => @user.to_param
        end

        should assign_to(:user) { @user }
        should respond_with(:success)
        should render_template(action)
      end
    end

    context 'on #GET to edit a user' do
      setup do
        get :edit, :id => @user.to_param
      end

      should assign_to(:user) { @user }
      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)
    end

    context "on #PUT to update a user" do
      setup do
        put :update, :id => @user.to_param, :user => {:signup_reason => "Haxx'd"}
      end

      should assign_to(:user) { @user }
      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)
      should "not update the signup reason" do
        assert_not_equal "Haxx'd", @user.reload.signup_reason
      end
    end
  end
end