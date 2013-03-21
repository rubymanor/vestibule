require 'test_helper'

class SuggestionsControllerTest < ActionController::TestCase
  def setup
    @viewer = FactoryGirl.create(:user)
    @proposer = FactoryGirl.create(:user)
    @proposal = FactoryGirl.create(:proposal, :proposer => @proposer)
  end

  context 'When visitor' do
    context 'on #POST to create' do
      setup do
        post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
      end

      should assign_to(:proposal) { @proposal }
      should assign_to(:suggestion)
      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)

      should "save suggestion" do
        assert !assigns(:suggestion).persisted?
      end
    end
  end

  context 'When viewer' do
    setup do
      session[:user_id] = @viewer.id
    end

    context 'on #POST to create' do
      setup do
        post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
      end

      should assign_to(:proposal) { @proposal }
      should assign_to(:suggestion)
      should respond_with(:redirect)
      should set_the_flash.to(/Your suggestion has been published/)

      should "save suggestion" do
        assert assigns(:suggestion).persisted?
      end
    end
  end

  context 'When proposer' do
    setup do
      session[:user_id] = @proposer.id
    end

    context 'on #POST to create' do
      setup do
        post :create, :proposal_id => @proposal.to_param, :suggestion => FactoryGirl.attributes_for(:suggestion)
      end

      should assign_to(:proposal) { @proposal }
      should assign_to(:suggestion)
      should respond_with(:redirect)
      should set_the_flash.to(/Your suggestion has been published/)

      should "save suggestion" do
        assert assigns(:suggestion).persisted?
      end
    end

  end
end