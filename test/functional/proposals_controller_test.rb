require 'test_helper'

class ProposalsControllerTest < ActionController::TestCase
  def setup
    @viewer = FactoryGirl.create(:user)
    @proposer = FactoryGirl.create(:user)
    @proposal = FactoryGirl.create(:proposal, :proposer => @proposer)
  end

  context 'When visitor' do
    context 'on #GET to index' do
      setup do
        @withdrawn_proposal = FactoryGirl.create(:proposal, :proposer => @proposer, :withdrawn => true)
        get :index
      end

      should respond_with(:success)
      should assign_to(:proposals) { [@proposal] }
      should assign_to(:withdrawn_proposals) { [@withdrawn_proposal] }
      should render_template('index')
    end

    context 'on #GET to show' do
      setup do
        get :show, :id => @proposal.to_param
      end

      should respond_with(:success)
      should assign_to(:proposal) { @proposal }
      should_not assign_to(:suggestion)
      should render_template('show')
    end

    context 'on #GET to new' do
      setup do
        get :new
      end

      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)
    end

    context 'on #POST to create' do
      setup do
        post :create, :proposal => FactoryGirl.attributes_for(:proposal)
      end

      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)

      should "not save proposal" do
        assert !assigns(:proposal).persisted?
      end
    end

    context 'on #GET to edit' do
      setup do
        get :edit, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)
    end

    context 'on #PUT to update' do
      setup do
        put :update, :id => @proposal.to_param, :proposal => {:title => 'Title Updated'}
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)

      should "not update proposal" do
        assert_not_equal 'Title Updated', @proposal.reload.title
      end
    end

    context 'on #POST to withdraw' do
      setup do
        post :withdraw, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)

      should "not withdraw proposal" do
        assert !@proposal.withdrawn?
      end
    end

    context 'on #POST to republish' do
      setup do
        @proposal.withdraw!
        post :republish, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You need to sign in or sign up before continuing/)

      should "not republish proposal" do
        assert @proposal.withdrawn?
      end
    end

    context 'on #POST to vote' do
      [:up, :down, :clear].each do |vote|
        context "with :#{vote}" do
          setup do
            post :vote, :id => @proposal.to_param, :vote => vote.to_s
          end

          should assign_to(:proposal) { @proposal }
          should respond_with(:redirect)
          should set_the_flash.to(/You need to sign in or sign up before continuing/)

          should "not count a vote" do
            assert_equal 0, @proposal.votes_for
            assert_equal 0, @proposal.votes_against
          end
        end
      end
    end
  end

  context 'When viewer is logged in' do
    setup do
      session[:user_id] = @viewer.id
    end

    context 'on #GET to index' do
      setup do
        get :index
      end

      should respond_with(:success)
      should assign_to(:proposals) { [@proposal] }
      should assign_to(:withdrawn_proposals) { [@withdrawn_proposal] }
      should render_template('index')
    end

    context 'on #GET to show' do
      setup do
        get :show, :id => @proposal.to_param
      end

      should respond_with(:success)
      should assign_to(:proposal) { @proposal }
      should assign_to(:suggestion)
      should render_template('show')
    end

    context 'on #GET to new' do
      setup do
        get :new
      end

      should respond_with(:success)
      should render_template('new')
    end

    context 'on #POST to create' do
      setup do
        post :create, :proposal => FactoryGirl.attributes_for(:proposal)
      end

      should respond_with(:redirect)

      should "save proposal" do
        assert assigns(:proposal).persisted?
      end

      should "assign proposal to user" do
        assert_equal @viewer, assigns(:proposal).proposer
      end
    end

    context 'on #GET to edit' do
      setup do
        get :edit, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You are not authorized to access this page/)
    end

    context 'on #PUT to update' do
      setup do
        put :update, :id => @proposal.to_param, :proposal => {:title => 'Title Updated'}
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You are not authorized to access this page/)

      should "not update proposal" do
        assert_not_equal 'Title Updated', @proposal.reload.title
      end
    end

    context 'on #POST to withdraw' do
      setup do
        post :withdraw, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You are not authorized to access this page/)

      should "not withdraw proposal" do
        assert !@proposal.withdrawn?
      end
    end

    context 'on #POST to republish' do
      setup do
        @proposal.withdraw!
        post :republish, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/You are not authorized to access this page/)

      should "not republish proposal" do
        assert @proposal.withdrawn?
      end
    end

    context 'on #POST to vote' do
      context "with :up" do
        setup do
          post :vote, :id => @proposal.to_param, :vote => 'up'
        end

        should assign_to(:proposal) { @proposal }
        should respond_with(:redirect)
        should set_the_flash.to(/Thank you for casting your vote. Your vote has been captured!/)

        should "count an upvote" do
          assert_equal 1, @proposal.votes_for
        end

        should "not count a downvote" do
          assert_equal 0, @proposal.votes_against
        end
      end

      context "with :down" do
        setup do
          post :vote, :id => @proposal.to_param, :vote => 'down'
        end

        should assign_to(:proposal) { @proposal }
        should respond_with(:redirect)
        should set_the_flash.to(/Thank you for casting your vote. Your vote has been captured!/)

        should "not count an downvote" do
          assert_equal 0, @proposal.votes_for
        end

        should "count a downvote" do
          assert_equal 1, @proposal.votes_against
        end
      end

      context "with :clear" do
        setup do
          @viewer.vote_for(@proposal)
          post :vote, :id => @proposal.to_param, :vote => 'clear'
        end

        should assign_to(:proposal) { @proposal }
        should respond_with(:redirect)
        should set_the_flash.to('Your vote has been cleared. Remember to come back to vote again once you are sure!')

        should "neutralize votes" do
          assert_equal 0, @proposal.votes_for
          assert_equal 0, @proposal.votes_against
        end
      end
    end
  end

  context 'When proposer is logged in' do
    setup do
      session[:user_id] = @proposer.id
    end

    context 'on #GET to index' do
      setup do
        get :index
      end

      should respond_with(:success)
      should assign_to(:proposals) { [@proposal] }
      should assign_to(:withdrawn_proposals) { [@withdrawn_proposal] }
      should render_template('index')
    end

    context 'on #GET to show' do
      setup do
        get :show, :id => @proposal.to_param
      end

      should respond_with(:success)
      should assign_to(:proposal) { @proposal }
      should assign_to(:suggestion)
      should render_template('show')
    end

    context 'on #POST to create' do
      setup do
        post :create, :proposal => FactoryGirl.attributes_for(:proposal)
      end

      should respond_with(:redirect)

      should "save proposal" do
        assert assigns(:proposal).persisted?
      end

      should "assign proposal to user" do
        assert_equal @proposer, assigns(:proposal).proposer
      end
    end

    context 'on #GET to edit' do
      setup do
        get :edit, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:success)
      should render_template('edit')
    end

    context 'on #PUT to update' do
      setup do
        put :update, :id => @proposal.to_param, :proposal => {:title => 'Title Updated'}
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)

      should "update proposal" do
        assert_equal 'Title Updated', @proposal.reload.title
      end
    end

    context 'on #POST to withdraw' do
      setup do
        post :withdraw, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/Your proposal has been withdrawn/)

      should "withdraw proposal" do
        assert @proposal.reload.withdrawn?
      end
    end

    context 'on #POST to republish' do
      setup do
        @proposal.withdraw!
        post :republish, :id => @proposal.to_param
      end

      should assign_to(:proposal) { @proposal }
      should respond_with(:redirect)
      should set_the_flash.to(/Your proposal has been republished/)

      should "republish proposal" do
        assert !@proposal.reload.withdrawn?
      end
    end

    context 'on #POST to vote' do
      [:up, :down, :clear].each do |vote|
        context "with :#{vote}" do
          setup do
            post :vote, :id => @proposal.to_param, :vote => vote.to_s
          end

          should assign_to(:proposal) { @proposal }
          should respond_with(:redirect)
          should set_the_flash.to(/You are not authorized to access this page/)

          should "not count a vote" do
            assert_equal 0, @proposal.votes_for
            assert_equal 0, @proposal.votes_against
          end
        end
      end
    end
  end
end