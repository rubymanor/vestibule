require "test_helper"

class SelectionTest < IntegrationTestCase
  context "Given a bunch of proposals" do
    setup do
      @destroy_ruby = Factory(:proposal, :title => "Destroy Ruby")
      @hot_gem = Factory(:proposal, :title => "My Hot New Gem")
      @merb = Factory(:proposal, :title => "I Miss Merb")
    end
    
    context "a logged in user" do
      setup do
        sign_in Factory(:user)
      end

      should "be able to select their preferred proposals" do
        visit "/"
        click_link "My selections"
        select_proposal "Destroy Ruby"
        select_proposal "I Miss Merb"
        assert page.has_css?("#selections a", :text => "Destroy Ruby")
        assert page.has_css?("#selections a", :text => "I Miss Merb")
        assert page.has_no_css?("#selections a", :text => "My Hot New Gem")
      end

      context "having selected some proposals" do
        setup do
          visit "/"
          click_link "My selections"
          select_proposal "Destroy Ruby"
        end

        should "be able to deselect them" do
          deselect_proposal "Destroy Ruby"
          assert page.has_no_css?("#selections a", :text => "Destroy Ruby")
        end
      end
    end
  end
end