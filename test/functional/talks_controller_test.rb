require 'test_helper'

class TalksControllerTest < ActionController::TestCase
  context "the index action" do
    should "respond successfully" do
      get :index
      assert_response :success
    end

    should "render the talks/index template" do
      get :index
      assert_template 'talks/index'
    end

    should "prepare a list of talks in newest first order" do
      talk_1 = Factory.create(:talk, :created_at => 10.days.ago)
      talk_2 = Factory.create(:talk, :created_at => 1.minute.ago)
      talk_3 = Factory.create(:talk, :created_at => 10.minutes.ago)
      talk_4 = Factory.create(:talk, :created_at => 4.days.ago)
      get :index
      assert_in_order assigns['talks'], talk_2, talk_3, talk_4, talk_1
    end
  end

  context "the show action" do
    setup do
      @talk = Factory.create(:talk)
    end

    should "respond successfully" do
      get :show, :id => @talk
      assert_response :success
    end

    should "render the talks/show template" do
      get :show, :id => @talk
      assert_template 'talks/show'
    end

    should "fetch the requested talk" do
      get :show, :id => @talk
      assert_equal @talk, assigns['talk']
    end
  end
end
