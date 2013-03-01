require "test_helper"

class ProposalSuggestionTest < IntegrationTestCase

  context "Given a talk proposal" do
    setup do
      @proposer = FactoryGirl.create(:user)
      @proposal = FactoryGirl.create(:proposal, :proposer => @proposer)
    end

    context "a visitor viewing the proposal" do
      setup do
        visit proposal_path(@proposal)
      end

      should "not be able to suggest anything" do
        refute page.has_css?("form[action='#{proposal_suggestions_path(@proposal)}']")
      end

      should "be able to subscribe to the rss feed of suggestions to the proposal" do
        visit proposal_path(@proposal)
        assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposal_path(@proposal, :format => :rss)}']")
        visit proposal_path(@proposal, :format => :rss)
        assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
      end
    end

    context "a logged in user viewing the proposal" do
      setup do
        @me = FactoryGirl.create(:user)
        sign_in @me
      end

      context 'when the app is in cfp mode' do
        setup do
          Vestibule.mode_of_operation = :cfp
          visit proposal_path(@proposal)
        end

        should "be able to subscribe to the rss feed of suggestions to the proposal" do
          assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposal_path(@proposal, :format => :rss)}']")
          visit proposal_path(@proposal, :format => :rss)
          assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
        end

        should "see a call to action asking for help to develop the proposal" do
          assert page.has_content?("Help develop this into a good proposal")
        end

        should "be able to make a suggestion about the proposal" do
          suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

          assert_page_has_suggestion :body => "I think you should focus on the first bit, because that's going to be more interesting to newbies.",
                                     :author => @me
        end

        should "be able to make a suggestion about the proposal and preserve the markdown content when displaying it" do
          suggest %{
1. change the title - it's not really clear
2. put more emphasis on how you'd test your approach
3. cover this gem: http://rubygems.org/gems/sausage-mcmuffin

Other than that, sounds great!
          }

          within ".suggestions" do
            assert page.has_css?("ol li", :text => "change the title - it's not really clear")
            assert page.has_css?("ol li", :text => "put more emphasis on how you'd test your approach")
            assert page.has_css?("ol li", :text => "cover this gem: http://rubygems.org/gems/sausage-mcmuffin")
            assert page.has_css?("ol li a[href='http://rubygems.org/gems/sausage-mcmuffin']", :text => 'http://rubygems.org/gems/sausage-mcmuffin')
            assert page.has_css?("p", :text => "Other than that, sounds great!")
          end
        end

        context 'when there are some suggestions already' do
          setup do
            @other_suggestion = FactoryGirl.create(:suggestion, :proposal => @proposal, :created_at => 2.days.ago, :updated_at => 2.days.ago)
          end

          should "be able to subscribe to the rss feed of suggestions to the proposal" do
            assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposal_path(@proposal, :format => :rss)}']")
            visit proposal_path(@proposal, :format => :rss)
            assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
          end

          should 'see the existing suggestions in the feed' do
            visit proposal_path(@proposal, :format => :rss)
            assert page.has_xpath?('.//item/title', :text => "Suggestion from #{@other_suggestion.author.name} (@#{@other_suggestion.author.github_nickname})")
            assert page.has_xpath?('.//item/description', :text => @other_suggestion.body)
          end

          should 'be able to add a new suggestion and see it in the feed at the top' do
            suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

            visit proposal_path(@proposal, :format => :rss)

            assert page.has_xpath?('.//item[position() = 2]/title', :text => "Suggestion from #{@other_suggestion.author.name} (@#{@other_suggestion.author.github_nickname})")
            assert page.has_xpath?('.//item[position() = 2]/description', :text => @other_suggestion.body)

            assert page.has_xpath?('.//item[position() = 1]/title', :text => "Suggestion from #{@me.name} (@#{@me.github_nickname})")
            assert page.has_xpath?('.//item[position() = 1]/description', :text => "I think you should focus on the first bit, because that's going to be more interesting to newbies.")
          end
        end

        should "anonymise suggestions by the proposer" do
          suggestion = FactoryGirl.create(:suggestion, :proposal => @proposal, :author => @proposer)
          visit proposal_path(@proposal)

          assert page.has_no_content?(@proposer.name)
          assert page.has_content?("The proposal author")
        end

        should "not be able to make an empty suggestion" do
          suggest ""
          i_am_warned_about Suggestion, :body, "can't be blank"
        end

        should "be required to provide a substantial suggestion" do
          suggest "x"*49
          i_am_warned_about Suggestion, :body, "should be a meaningful contribution or criticism (i.e. at least 50 characters)"
        end

        should "not be able to make a '+1' suggestion" do
          suggest "+1"
          i_am_warned_about Suggestion, :body, "should contain some concrete suggestions about how to develop this proposal"
        end

        should "not be able to make a '-1' suggestion" do
          suggest "-1"
          i_am_warned_about Suggestion, :body, "should contain some concrete suggestions about how to develop this proposal"
        end
      end

      context 'when the app is in review mode' do
        setup do
          Vestibule.mode_of_operation = :review
          visit proposal_path(@proposal)
        end

        should "see a call to action asking for help to develop the proposal" do
          assert page.has_content?("Help develop this into a good proposal")
        end

        should "be able to make a suggestion about the proposal" do
          suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

          assert_page_has_suggestion :body => "I think you should focus on the first bit, because that's going to be more interesting to newbies.",
                                     :author => @me
        end
      end

      context 'when the app is in voting mode' do
        setup do
          Vestibule.mode_of_operation = :voting
          visit proposal_path(@proposal)
        end

        should "see a call to action asking for help to develop the proposal" do
          assert page.has_content?("Help develop this into a good proposal")
        end

        should "be able to make a suggestion about the proposal" do
          suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

          assert_page_has_suggestion :body => "I think you should focus on the first bit, because that's going to be more interesting to newbies.",
                                     :author => @me
        end
      end

      context 'when the app is in agenda mode' do
        setup do
          Vestibule.mode_of_operation = :agenda
          visit proposal_path(@proposal)
        end

        should "see a call to action asking for help to develop the proposal" do
          assert page.has_content?("Help develop this into a good proposal")
        end

        should "be able to make a suggestion about the proposal" do
          suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

          assert_page_has_suggestion :body => "I think you should focus on the first bit, because that's going to be more interesting to newbies.",
                                     :author => @me
        end
      end

      context 'when the app is in archive mode' do
        setup do
          Vestibule.mode_of_operation = :archive
          visit proposal_path(@proposal)
        end

        should "not see a call to action asking for help to develop the proposal" do
          refute page.has_content?("Help develop this into a good proposal")
        end

        should "not be able to suggest anything" do
          refute page.has_css?("form[action='#{proposal_suggestions_path(@proposal)}']")
        end
      end

      context "a proposer viewing their proposal" do
        setup do
          sign_in @proposer
          visit proposal_path(@proposal)
        end

        should "see a call to action explaining anonymisation" do
          assert page.has_content?("your identity will be masked from other visitors")
        end

        should "see their suggestions identified as their own" do
          suggestion = FactoryGirl.create(:suggestion, :proposal => @proposal, :author => @proposer)
          visit proposal_path(@proposal)

          assert page.has_content?("You respond")
        end

      end
    end
  end

  def suggest(body)
    fill_in "suggestion[body]", :with => body
    click_button "Make your suggestion"
  end
end
