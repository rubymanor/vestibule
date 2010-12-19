require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  context "the create action" do
    setup do
      @talk = Factory.create(:talk)
      @valid_params = {:content => Faker::Lorem.paragraph}
      @invalid_params =  {:content => 's'}
      @talk.feedbacks.clear
      @talk.contributions.discussions.clear
    end

    context "when the user is not signed in" do
      setup do
        sign_out :user
      end

      should "tell the user they're not allowed in" do
        post :create, :talk_id => @talk.to_param, :feedback => @valid_params
        assert_redirected_to new_user_session_path
      end
    end

    context "when the user is signed in" do
      setup do
        @user = Factory.create(:user)
        sign_in :user, @user
      end

      context "when valid data is provided" do
        should "redirect to the show page of the talk the feedback was left for" do
          post :create, :talk_id => @talk.to_param, :feedback => @valid_params
          assert_redirected_to talk_path(@talk)
        end

        should "create a new item of feedback on the talk that is owned by the user" do
          post :create, :talk_id => @talk.to_param, :feedback => @valid_params
          new_feedback = @talk.feedbacks(true).first
          assert_equal @user, new_feedback.user
        end

        should "add a new 'discuss' contribution to the talk in question for the user" do
          post :create, :talk_id => @talk.to_param, :feedback => @valid_params
          new_contribution = @talk.contributions.discussions(true).first
          assert_equal @user, new_contribution.user
        end

        should "ignore a talk_id param in the feedback params" do
          other_talk = Factory.create(:talk)
          post :create, :talk_id => @talk.to_param, :feedback => @valid_params.merge(:talk_id => other_talk.to_param)
          assert other_talk.feedbacks(true).empty?
        end

        should "ignore a user_id param in the feedback params" do
          other_user = Factory.create(:user)
          post :create, :talk_id => @talk.to_param, :feedback => @valid_params.merge(:user_id => other_user.to_param)
          new_feedback = @talk.feedbacks(true).first
          assert_not_equal other_user, new_feedback.user
        end
      end

      context "when invalid data is provided" do
        should "render the talks/show template" do
          post :create, :talk_id => @talk.to_param, :feedback => @invalid_params
          assert_template 'talks/show'
        end

        should "make the owning talk object available as @talk" do
          post :create, :talk_id => @talk.to_param, :feedback => @invalid_params
          assert_equal @talk, assigns['talk']
        end

        should "make the invalid feedback object available as @new_feedback" do
          # TODO - don't like this ... mocking would feel cleaner
          post :create, :talk_id => @talk.to_param, :feedback => @invalid_params
          assert assigns['new_feedback'].new_record?
          assert !assigns['new_feedback'].valid?
          assert_equal @invalid_params[:content], assigns['new_feedback'].content
        end
      end
    end
  end
end
