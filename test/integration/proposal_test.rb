require "test_helper"

class ProposalTest < IntegrationTestCase
  
  context "As a visitor to the site" do
    should "not see a link to propose a talk" do
      visit proposals_path
      assert !page.has_content?("Propose talk"), "link to propose talk should not be present!"
    end

    should "not be able to propose a talk" do
      visit new_proposal_path
      i_am_asked_to_sign_in
    end

    context "given a proposal already exists" do
      setup do
        Factory(:proposal, :title => "Ruby Muby Schmuby")
      end

      should "be able to see the list of proposals" do
        visit proposals_path
        assert page.has_css?('ul.proposals')
      end

      should "be able to read individual proposals" do
        visit proposals_path
        click_link "Ruby Muby Schmuby"
        assert_page_has_proposal :title => "Ruby Muby Schmuby"
      end
    end
  end

  context "Given I am logged in" do
    setup do
      @account = Factory(:account, :email => 'tom@example.com')
      sign_in(@account)
    end

    context "and I propose a talk with all the required details" do
      setup { propose_talk :title => "My Amazing Talk", :description => 'This talk is amazing.' }

      should "be able to see my proposal on the site" do
        visit proposals_path
        click_link "My Amazing Talk"
        assert_page_has_proposal \
          :title        => "My Amazing Talk",
          :description  => 'This talk is amazing.',
          :proposer     => 'tom@example.com'
      end
    end

    context "and I propose a talk without a title" do
      setup { propose_talk :title => nil }

      should "alert me that the title is required" do
        i_am_warned_about Proposal, :title, "can't be blank"
      end
    end
  end

end