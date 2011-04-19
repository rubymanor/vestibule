require "test_helper"

class ProposalSuggestionTest < IntegrationTestCase

  context "Given a talk proposal" do
    setup do
      @proposer = Factory(:account)
      @proposal = Factory(:proposal, :proposer => @proposer.user)
    end

    context "a visitor viewing the proposal" do
      setup do
        visit proposal_path(@proposal)
      end

      should "not be able to suggest anything" do
        refute page.has_css?("form[action='#{proposal_suggestions_path(@proposal)}']")
      end
    end

    context "a logged in user viewing the proposal" do
      setup do
        @account = Factory(:account)
        sign_in @account
        visit proposal_path(@proposal)
      end

      should "be able to make a suggestion about the proposal" do
        suggest "I think you should focus on the first bit, because that's going to be more interesting to newbies."

        within ".suggestions" do
          i_can_see_the_gravatar_for_account @account
          assert page.has_content?("I think you should focus on the first bit")
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