require "test_helper"

class ProposalTest < ActiveSupport::TestCase
  context "A proposal" do
    setup do
      @proposal = FactoryGirl.create(:proposal)
    end

    should "be valid" do
      assert @proposal.valid?
    end

    context "last modified" do

      should "be last modified when updated after last suggestion was added" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }
        Timecop.freeze(Time.parse("Sep 4 2011")) do
          @proposal.description = "Now change something"
          @proposal.save!
        end

        assert_equal Time.parse("Sep 4 2011"), @proposal.last_modified
      end

      should "be last modified when last suggestion was added" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }

        assert_equal Time.parse("Sep 3 2011"), @proposal.last_modified
      end

      should "be last modified when last suggestion was added by proposer" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }
        Timecop.freeze(Time.parse("Sep 5 2011")) { FactoryGirl.create(:suggestion, :proposal => @proposal, :author => @proposal.proposer) }

        assert_equal Time.parse("Sep 5 2011"), @proposal.last_modified
      end

      should "be last modified when it was last updated" do
        assert_equal @proposal.updated_at, @proposal.last_modified
      end
    end

    context 'in modification order' do
      should 'be the same as updated at order when no suggestions have been made' do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal.title = 'Meh'; @proposal.save }
        Timecop.freeze(Time.parse("Sep 1 2012")) { @proposal_2 = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 1 2010")) { @proposal_3 = FactoryGirl.create(:proposal) }

        assert_equal [@proposal_2, @proposal, @proposal_3], Proposal.in_modification_order
      end

      should 'use the latest suggestion time to influence sorting' do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal.title = 'Meh'; @proposal.save }
        Timecop.freeze(Time.parse("Sep 1 2012")) { @proposal_2 = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 1 2010")) { @proposal_3 = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 1 2012")) { FactoryGirl.create(:suggestion, :proposal => @proposal_3) }
        Timecop.freeze(Time.parse("Sep 2 2012")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }
        Timecop.freeze(Time.parse("Sep 3 2012")) { FactoryGirl.create(:suggestion, :proposal => @proposal_3) }

        assert_equal [@proposal_3, @proposal, @proposal_2], Proposal.in_modification_order
      end

      should 'prefer proposal updated time to a suggestion time to influence sorting' do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal.title = 'Meh'; @proposal.save }
        Timecop.freeze(Time.parse("Sep 1 2012")) { @proposal_2 = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 1 2010")) { @proposal_3 = FactoryGirl.create(:proposal) }
        Timecop.freeze(Time.parse("Sep 2 2012")) { FactoryGirl.create(:suggestion, :proposal => @proposal) }
        Timecop.freeze(Time.parse("Sep 3 2012")) { FactoryGirl.create(:suggestion, :proposal => @proposal_3) }
        Timecop.freeze(Time.parse("Sep 3 2012")) { @proposal.title = 'Meh heh!'; @proposal.save }

        assert_equal [@proposal, @proposal_3, @proposal_2], Proposal.in_modification_order
      end
    end
  end

end
