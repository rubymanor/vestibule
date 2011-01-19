require "test_helper"

class TalkProposalTest < IntegrationTestCase
  
  context "As a visitor to the site" do
    should "not see a link to propose a talk" do
      visit talks_path
      assert !page.has_content?("Propose talk"), "link to propose talk should not be present!"
    end

    should "not be able to propose a talk" do
      visit new_talk_path
      i_am_asked_to_sign_in
    end
  end

  context "Given I am logged in" do
    setup { sign_in }

    context "and I propose a talk with all the required details" do
      setup { propose_talk :title => "My Amazing Talk" }

      should "be able to see the proposal on the site" do
        visit talks_path
        click_link "My Amazing Talk"
        assert_page_has_talk :title => "My Amazing Talk"
      end
    end
  end

end