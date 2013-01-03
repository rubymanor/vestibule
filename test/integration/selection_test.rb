require "test_helper"

class SelectionTest < IntegrationTestCase
  context "Given a bunch of proposals" do
    setup do
      @destroy_ruby = FactoryGirl.create(:proposal, :title => "Destroy Ruby")
      @hot_gem = FactoryGirl.create(:proposal, :title => "My Hot New Gem")
      @merb = FactoryGirl.create(:proposal, :title => "I Miss Merb")
    end
    
    context "a logged in user" do
      setup do
        sign_in FactoryGirl.create(:user)
      end

      should "be able to select their preferred proposals" do
        visit "/"
        click_link "Selections"
        select_proposal "Destroy Ruby"
        select_proposal "I Miss Merb"
        assert page.has_css?("#selections a", :text => "Destroy Ruby")
        assert page.has_css?("#selections a", :text => "I Miss Merb")
        assert page.has_no_css?("#selections a", :text => "My Hot New Gem")
      end

      should "only be able to select 8 proposals" do
        proposals = (1..8).to_a.map { FactoryGirl.create(:proposal) }
        visit "/"
        click_link "Selections"
        8.times { |x| select_proposal proposals[x].title }
        select_proposal "Destroy Ruby"
        i_am_alerted "You can only select 8 proposals at a time"
      end

      context "having selected some proposals" do
        setup do
          visit "/"
          click_link "Selections"
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