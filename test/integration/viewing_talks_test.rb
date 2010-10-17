require 'test_helper'

class ViewingTalksTest < IntegrationTestCase
  setup do
    @talk_1 = Factory.create(:talk, :title => 'Jumping for joy with <Ruby>!', :created_at => 10.days.ago, :updated_at => 9.days.ago)
    @talk_2 = Factory.create(:talk, :title => 'Touching RedCloth', :created_at => 1.minute.ago, :updated_at => 1.minute.ago)
    @talk_3 = Factory.create(:talk, :title => 'Pass the salt father, Oh! and by the way, I use Ruby', :created_at => 10.minutes.ago, :updated_at => 10.minutes.ago)
    @talk_4 = Factory.create(:talk, :title => 'To Ruby or not to Ruby', :created_at => 4.days.ago, :updated_at => 2.minutes.ago)
  end

  scenario "I can visit the talks index and see a list of talks that link to individual talk pages" do
    visit '/'

    the_page_has_title 'Talks'

    within('#talks') do
      assert_in_order all('.talk').map {|li| li.text}, @talk_2.title, @talk_4.title, @talk_3.title, @talk_1.title
    end

    click @talk_1.title

    i_am_on talk_path(@talk_1)
  end

  scenario "When viewing the page about a talk I can see all the details of that talk that have been filled in, and am prompted to fill in the missing ones" do
    visit talk_path(@talk_1)

    the_page_has_title @talk_1.title

    within('#abstract') do
      assert page.has_content?('No abstract has been provided yet.')
      assert page.has_link?('Why don\'t you fill it in?')
      click 'Why don\'t you fill it in?'
    end

    i_am_on edit_talk_path(@talk_1)
    fill_in "Abstract", :with => 'This talk will cover why I think ruby is a joyful language.'
    click_button 'Update suggestion'
    within('#abstract') do
      assert page.has_content?('This talk will cover why I think ruby is a joyful language.')
      assert page.has_no_link?('Why don\'t you fill it in?')
    end

    within('#outline') do
      assert page.has_content?('No outline has been provided yet.')
      assert page.has_link?('Why don\'t you fill it in?')
      click 'Why don\'t you fill it in?'
    end

    i_am_on edit_talk_path(@talk_1)
    fill_in "Outline", :with => 'The first slides will cover my "Aw yeah!" moment with Ruby. The next slides will be the same thing from some other rubyists. It\'ll finish up with ways you can help other programmers experience their own "Aw yeah!" moments when they first experience ruby.'
    click_button 'Update suggestion'
    within('#outline') do
      assert page.has_content?('The first slides will cover my "Aw yeah!" moment with Ruby. The next slides will be the same thing from some other rubyists. It\'ll finish up with ways you can help other programmers experience their own "Aw yeah!" moments when they first experience ruby.')
      assert page.has_no_link?('Why don\'t you fill it in?')
    end

    within('#why_its_interesting') do
      assert page.has_content?('Nothing about why this talk is interesting has been provided yet.')
      assert page.has_link?('Why don\'t you fill it in?')
      click 'Why don\'t you fill it in?'
    end

    i_am_on edit_talk_path(@talk_1)
    fill_in "Why it's interesting?", :with => 'Day to day programming can be dull and enterprisey. We need reminding of why we\'ve chosen Ruby. And we need to be able to pass on that excitement to others.'
    click_button 'Update suggestion'
    within('#why_its_interesting') do
      assert page.has_content?('Day to day programming can be dull and enterprisey. We need reminding of why we\'ve chosen Ruby. And we need to be able to pass on that excitement to others.')
      assert page.has_no_link?('Why don\'t you fill it in?')
    end
  end
end
