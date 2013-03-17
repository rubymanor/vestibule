require 'test_helper'

class ProposalsControllerTest < ActionController::TestCase
  def setup
    @viewer = FactoryGirl.create(:user)
    @proposer = FactoryGirl.create(:user)
    @proposal = FactoryGirl.create(:proposal, :proposer => @proposer)
  end

  context 'When visitor' do
    context 'on #POST to vote' do
      [:up, :down, :clear].each do |vote|
        context "with :#{vote}" do
          setup do
            post :vote, :id => @proposal.to_param, :vote => vote.to_s
          end

          should respond_with(:redirect)
          should set_the_flash.to(/You need to sign in/)

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

    context 'on #POST to vote' do
      [:up, :down, :clear].each do |vote|
        context "with :#{vote}" do
          setup do
            post :vote, :id => @proposal.to_param, :vote => vote.to_s
          end

          should assign_to(:proposal) { @proposal }
          should respond_with(:redirect)
          should set_the_flash.to(/You can't vote for your own proposal!/)

          should "not count a vote" do
            assert_equal 0, @proposal.votes_for
            assert_equal 0, @proposal.votes_against
          end
        end
      end
    end
  end
end