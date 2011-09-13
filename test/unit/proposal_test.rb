require "test_helper"

class ProposalTest < ActiveSupport::TestCase
  context "A proposal" do
    setup do
      @proposal = Factory(:proposal)
    end

    should "be valid" do
      assert @proposal.valid?
    end

    context "last modified" do

      should "be last modified when updated after last suggestion was added" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = Factory(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { Factory(:suggestion, :proposal => @proposal) }
        Timecop.freeze(Time.parse("Sep 4 2011")) do
          @proposal.description = "Now change something"
          @proposal.save!
        end

        assert_equal Time.parse("Sep 4 2011"), @proposal.last_modified
      end

      should "be last modified when last suggestion was added" do
        Timecop.freeze(Time.parse("Sep 1 2011")) { @proposal = Factory(:proposal) }
        Timecop.freeze(Time.parse("Sep 3 2011")) { Factory(:suggestion, :proposal => @proposal) }

        assert_equal Time.parse("Sep 3 2011"), @proposal.last_modified
      end

      should "be last modified when it was last updated" do
        assert_equal @proposal.updated_at, @proposal.last_modified
      end
    end

  end

end
