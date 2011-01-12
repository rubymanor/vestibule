require 'test_helper'

class SuggestingATalkTest < IntegrationTestCase
  setup do
    @talk_1 = Factory.create(:talk, :title => 'Jumping for joy with <Ruby>!', :created_at => 10.days.ago, :updated_at => 9.days.ago)
    @talk_2 = Factory.create(:talk, :title => 'Touching RedCloth', :created_at => 1.minute.ago, :updated_at => 1.minute.ago)
  end

  context "As a visitor" do
    scenario "When I view the talks index page, I am prompted to sign up / sign in in order to suggest a talk" do
      visit '/talks'

      within ".actions" do
        there_are_sign_up_and_sign_in_links
      end

      assert page.has_no_link?('Suggest a new talk')
    end

    scenario "When I view a page about a talk, I am prompted to sign up / sign in if I want to flesh it out somewhat" do
      visit talk_path(@talk_1)

      within ".actions" do
        there_are_sign_up_and_sign_in_links
      end

      assert page.has_no_link?('Provide more detail')
    end
  end

  context "As a signed in user" do
    setup do
      @me = Factory.create(:user)
      sign_in @me
    end

    scenario "When I view the talks index page I am prompted to suggest a talk, and when I do, it appears at the top of the list of talks" do
      how_many_talks = Talk.count

      visit '/talks'

      click 'Suggest a new talk'

      i_am_on new_talk_path

      the_page_has_title 'Suggest a new talk'

      click_button 'Suggest'

      assert_equal how_many_talks, Talk.count

      assert page.has_content?('Some errors were found, please take a look:')

      i_fill_in_and_suggest_a_talk with_title: 'The best little rubyhouse in Texas',
                                   with_abstract: 'Ever wondered what it would be like to live in a house where everything is programmable via ruby?'

      assert_equal how_many_talks + 1, Talk.count
      i_am_on talks_path

      within '#talks .talk:first-child' do
        assert page.has_content?('The best little rubyhouse in Texas')
      end
    end

    scenario "When I view the page about a talk I am able to edit it to flesh out some of the details that the original suggester left blank, and this pushes the talk to the top of the list" do
      visit talk_path(@talk_1)

      click 'Provide more detail'

      i_am_on edit_talk_path(@talk_1)

      the_page_has_title "Provide more detail for Talk '#{@talk_1.title}'"

      i_provde_more_detail_for_a_talk with_abstract: 'A whirlwind journey through why Ruby is so amazing.  I guarantee that by the end you\'ll be jumping with joy!',
                                      with_why_its_interesting: 'Everyone is obsessed with technical details and performance of VMs etc.  I want to get back to the simple joys of why we all chose ruby in the first place.  We all had that "Oh yeah!" moment when learning Ruby, I want to remind you of it.'

      i_am_on talk_path(@talk_1)

      click 'Back to talks'

      within '#talks .talk:first-child' do
        assert page.has_content? @talk_1.title
      end
    end

    def i_fill_in_and_suggest_a_talk(options = {})
      fill_in 'Title', :with => options[:with_title]
      fill_in 'Abstract', :with => options[:with_abstract]
      click_button 'Suggest'
    end

    def i_provde_more_detail_for_a_talk(options = {})
      fill_in 'Abstract', :with => options[:with_abstract]
      fill_in 'Why it\'s interesting?', :with => options[:with_why_its_interesting]
      click_button 'Update suggestion'
    end
  end
end