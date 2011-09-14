require "test_helper"

class DashboardTest < IntegrationTestCase

  context "Given a bunch of proposals with varying amounts of feedback" do
    setup do
      @me = Factory(:user)

      @proposal1 = Factory(:proposal)
      @proposal2 = Factory(:proposal)
      @proposal3 = Factory(:proposal)

      @my_proposal = Factory(:proposal, :proposer => @me)

      Factory(:suggestion, :proposal => @proposal2)
      Factory(:suggestion, :proposal => @proposal2)
      Factory(:suggestion, :proposal => @proposal2)

      Factory(:suggestion, :proposal => @proposal1)
    end

    context "When I visit my dashboard" do
      setup do
        sign_in @me
        visit "/dashboard"
      end

      should "see a list of proposals I made" do
        within('#your-proposals') do
          assert page.has_content?(@my_proposal.title), "proposal was missing"
        end
      end

      context "and some new suggestions have been made for one of my proposals" do
        setup do
          Timecop.travel 5.minutes.from_now
          Factory(:suggestion, :proposal => @my_proposal)
          Factory(:suggestion, :proposal => @my_proposal, :author => @me)
          Timecop.travel 5.minutes.from_now
          Factory(:suggestion, :proposal => @my_proposal)
          Factory(:suggestion, :proposal => @my_proposal)
          visit "/dashboard"
        end

        should "show in the list that there are new suggestions" do
          within_object("#your-proposals", @my_proposal) do
            assert page.has_content?("2 new suggestions"), "proposal should indicate it has new suggestions"
          end
        end

        context "but I've updated my proposal since" do
          setup do
            Timecop.travel 5.minutes.from_now
            @my_proposal.description = "Blah blah blah"
            @my_proposal.save!
            visit "/dashboard"
          end

          should "show in the list that there are no new suggestions" do
            within_object("#your-proposals", @my_proposal) do
              assert !page.has_content?('new suggestions'), "proposal should not appear to have new suggestions"
            end
          end

          should "not show my proposal as changed" do
            assert !page.has_css?("#things-have-changed"), "my proposal shouldn't be in the changed list"
          end
        end

        context "but I've added a suggestion to my proposal since" do
          setup do
            Timecop.travel 5.minutes.from_now
            Factory(:suggestion, :proposal => @my_proposal, :author => @me)
            visit "/dashboard"
          end

          should "show in the list that there are no new suggestions" do
            within_object("#your-proposals", @my_proposal) do
              assert !page.has_content?('new suggestions'), "proposal should not appear to have new suggestions"
            end
          end
        end
      end

      should "see a list of talks that I haven't made any suggestions for" do
        within('#you-should-look-at-these') do
          assert page.has_content?(@proposal1.title), "proposal1 was missing"
          assert page.has_content?(@proposal2.title), "proposal2 was missing"
          assert page.has_content?(@proposal3.title), "proposal3 was missing"
        end
      end

      should "link to individual suggestions" do
        click_link @proposal1.title
        assert_equal proposal_path(@proposal1), current_path
      end

      should "not see proposals I made in the list of talks requiring suggestions" do
        within('#you-should-look-at-these') do
          assert !page.has_content?(@my_proposal.title), "my proposal shouldn't be presented as requiring suggestions"
        end
      end

      context "And I have made suggestions for one of the talks" do
        setup do
          Factory(:suggestion, :proposal => @proposal1, :author => @me)
          visit '/dashboard'
        end

        should "not see that talk in the list I haven't made suggestions for" do
          within('#you-should-look-at-these') do
            assert !page.has_content?(@proposal1.title), "proposal1 shouldn't be in the attention list"
          end
        end

        context "and I have made suggestions for other talks with recent activity" do
          setup do
            Factory(:suggestion, :author => @me, :proposal => @proposal2)
            Timecop.travel 10.minutes
            @proposal2.update_attributes! :description => 'Now more interesting than before.'
            visit '/dashboard'
          end

          should "not see that talk in my list of proposals with recent activity" do
            within('#things-have-changed') do
              assert !page.has_content?(@proposal1.title), "proposal1 shouldn't be in the changed list"
            end
          end
        end

        context "And the talk is then updated by the proposer" do
          setup do
            Timecop.travel 10.minutes.from_now

            @proposal1.description = "I will, of course, be covering what you need to look out for when using this gem on JRuby."
            @proposal1.save!

            Timecop.travel 1.minute.from_now
            visit '/dashboard'
          end

          should "see that talk in my list of proposals with recent activity" do
            within('#things-have-changed') do
              assert page.has_content?(@proposal1.title), "proposal1 should be in the changed list"
            end
          end
        end
      end

    end

  end
end