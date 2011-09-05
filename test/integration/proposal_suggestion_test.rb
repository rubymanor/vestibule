require "test_helper"

class ProposalSuggestionTest < IntegrationTestCase

  context "Given a talk proposal" do
    setup do
      @proposer = Factory(:user)
      @proposal = Factory(:proposal, :proposer => @proposer)
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
        @me = Factory(:user)
        sign_in @me
        visit proposal_path(@proposal)
      end

      should "be able to subscribe to the rss feed of suggestions to the proposal" do
        assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposal_path(@proposal, :format => :rss)}']")
        visit proposal_path(@proposal, :format => :rss)
        assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
      end

      should "be able to make a suggestion about the proposal" do
        suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

        within ".suggestions" do
          i_can_see_the_avatar_for_user @me
          assert page.has_content?("I think you should focus on the first bit")
        end
      end

      context 'when there are some suggestions already' do
        setup do
          @other_suggestion = Factory(:suggestion, :proposal => @proposal, :created_at => 2.days.ago, :updated_at => 2.days.ago)
        end

        should "be able to subscribe to the rss feed of suggestions to the proposal" do
          assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposal_path(@proposal, :format => :rss)}']")
          visit proposal_path(@proposal, :format => :rss)
          assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
        end

        should 'see the existing suggestions in the feed' do
          visit proposal_path(@proposal, :format => :rss)
          assert page.has_xpath?('.//item/title', :text => "Suggestion from #{@other_suggestion.author.name} (@#{@other_suggestion.author.twitter_nickname})")
          assert page.has_xpath?('.//item/description', :text => @other_suggestion.body)
        end

        should 'be able to add a new suggestion and see it in the feed at the top' do
          suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

          visit proposal_path(@proposal, :format => :rss)

          assert page.has_xpath?('.//item[position() = 2]/title', :text => "Suggestion from #{@other_suggestion.author.name} (@#{@other_suggestion.author.twitter_nickname})")
          assert page.has_xpath?('.//item[position() = 2]/description', :text => @other_suggestion.body)

          assert page.has_xpath?('.//item[position() = 1]/title', :text => "Suggestion from #{@me.name} (@#{@me.twitter_nickname})")
          assert page.has_xpath?('.//item[position() = 1]/description', :text => "I think you should focus on the first bit, because that's going to be more interesting to newbies.")
        end
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
  end

  def suggest(body)
    fill_in "suggestion[body]", :with => body
    click_button "Go"
  end
end