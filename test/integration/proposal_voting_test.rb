require "test_helper"

class ProposalVotingTest < IntegrationTestCase

  context "Given a talk proposal" do
    setup do
      @proposer = FactoryGirl.create(:user)
      @proposal = FactoryGirl.create(:proposal, :proposer => @proposer)
    end

    context "a visitor viewing the proposal" do
      setup do
        visit proposal_path(@proposal)
      end

      should "not be able to vote anything" do
        refute page.has_css?("a[href='#{vote_proposal_path(@proposal, :vote => :up)}']")
        refute page.has_css?("a[href='#{vote_proposal_path(@proposal, :vote => :down)}']")
      end
    end

    context "a logged in user viewing the proposal" do
      setup do
        @me = FactoryGirl.create(:user)
        sign_in @me
        visit proposal_path(@proposal)
      end

      should "see a call to action asking to vote for the proposal" do
        assert page.has_css?("a[href='#{vote_proposal_path(@proposal, :vote => :up)}']")
        assert page.has_css?("a[href='#{vote_proposal_path(@proposal, :vote => :down)}']")
      end

      should "be able to vote up a proposal" do
        vote_up
        assert_equal 1, @proposal.votes_for
        i_am_alerted 'Thank you for casting your vote. Your vote has been captured!'
      end

      should "be able to vote down" do
        vote_down
        assert_equal 1, @proposal.votes_against
        i_am_alerted 'Thank you for casting your vote. Your vote has been captured!'
      end

      context 'who has already voted for the proposal' do
        setup do
          @me.vote_for(@proposal)
          visit proposal_path(@proposal)
        end

        should "see a message informing me about what I have voted" do
          assert page.has_content?('You have already voted up this proposal.')
        end

        should "be able to withdraw my vote" do
          click_link 'Changed your mind?'
          vote_clear
          assert_equal 0, @proposal.votes_for
          assert_equal 0, @proposal.votes_against
          i_am_alerted 'Your vote has been cleared. Remember to come back to vote again once you are sure!'
        end

        should "be able to change my mind" do
          click_link 'Changed your mind?'
          vote_down
          assert_equal 0, @proposal.votes_for
          assert_equal 1, @proposal.votes_against
          i_am_alerted 'Thank you for casting your vote. Your vote has been captured!'
        end
      end
    end

    context "a proposer viewing their proposal" do
      setup do
        sign_in @proposer
        visit proposal_path(@proposal)
      end

      should "not see a call to action asking to vote for the proposal" do
        refute page.has_css?("a[href='#{vote_proposal_path(@proposal, :vote => :up)}']")
        refute page.has_css?("a[href='#{vote_proposal_path(@proposal, :vote => :down)}']")
      end
    end
  end

  #########
  protected
  #########

  def vote_up
    click_link "I would like to see this!"
  end

  def vote_down
    click_link "Not really interested..."
  end

  def vote_clear
    click_link "Not sure yet"
  end
end
