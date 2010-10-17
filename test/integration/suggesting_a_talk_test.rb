require 'test_helper'

class SuggestingATalkTest < IntegrationTestCase
  setup do
    @talk_1 = Factory.create(:talk, :title => 'Jumping for joy with <Ruby>!', :created_at => 10.days.ago)
    @talk_2 = Factory.create(:talk, :title => 'Touching RedCloth', :created_at => 1.minute.ago)
  end

  scenario "On the talks index I am prompted to suggest a talk, and when I do, it appears at the top of the list of talks" do
    how_many_talks = Talk.count

    visit '/talks'

    click 'Suggest a new talk'

    i_am_on new_talk_path

    the_page_has_title 'Suggest a new talk'

    click_button 'Suggest'

    assert_equal how_many_talks, Talk.count

    assert page.has_content?('Some errors were found, please take a look:')

    fill_in 'Title', :with => 'The best little rubyhouse in Texas'
    fill_in 'Abstract', :with => 'Ever wondered what it would be like to live in a house where everything is programmable via ruby?'

    click_button 'Suggest'

    assert_equal how_many_talks + 1, Talk.count
    i_am_on talks_path

    within '#talks li:first-child' do
      assert page.has_content?('The best little rubyhouse in Texas')
    end
  end
end