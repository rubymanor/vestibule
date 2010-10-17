require 'test_helper'

class ViewingTalksTest < IntegrationTestCase
  setup do
    @talk_1 = Factory.create(:talk, :title => 'Jumping for joy with <Ruby>!', :created_at => 10.days.ago)
    @talk_2 = Factory.create(:talk, :title => 'Touching RedCloth', :created_at => 1.minute.ago)
    @talk_3 = Factory.create(:talk, :title => 'Pass the salt father, Oh! and by the way, I use Ruby', :created_at => 10.minutes.ago)
    @talk_4 = Factory.create(:talk, :title => 'To Ruby or not to Ruby', :created_at => 4.days.ago)
  end

  scenario "I can visit the talks index and see a list of talks that link to individual talk pages" do
    visit '/'

    the_page_has_title 'Talks'

    within('#talks') do
      assert_in_order all('li.talk').map {|li| li.text}, @talk_2.title, @talk_3.title, @talk_4.title, @talk_1.title
    end

    click @talk_1.title

    i_am_on talk_path(@talk_1)

    the_page_has_title @talk_1.title
  end
end
