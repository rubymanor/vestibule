require 'test_helper'

class ProvidingFeedbackOnATalkTest < IntegrationTestCase
  setup do
    @talk = Factory.create(:talk, :title => 'Jumping for joy with <Ruby>!', :created_at => 10.days.ago, :updated_at => 9.days.ago)
    @feedback_1  = Factory.create(:feedback, :talk => @talk, :created_at => 10.days.ago)
    @feedback_2  = Factory.create(:feedback, :talk => @talk, :created_at => 1.minute.ago)
    @feedback_3  = Factory.create(:feedback, :talk => @talk, :created_at => 4.days.ago)
  end

  scenario "When I am not a logged in user I can see existing feedback, but I can't leave any.  I am however, prompted to sign up or login to do so" do
    visit talk_path(@talk)

    within('#feedback') do
      assert page.has_content?(@feedback_1.content)
      assert page.has_content?(@feedback_2.content)
      assert page.has_content?(@feedback_3.content)
      there_is_no_feedback_form
      there_are_sign_up_and_sign_in_links
    end
  end

  scenario "When I am a logged in user I can see existing feedback and leave some of my own, which appears at the bottom of the list of feedback" do
    sign_in

    visit talk_path(@talk)

    within('#feedback') do
      assert page.has_content?(@feedback_1.content)
      assert page.has_content?(@feedback_2.content)
      assert page.has_content?(@feedback_3.content)
      there_are_no_sign_up_and_sign_in_links
      there_is_a_feedback_form

      fill_in "Feedback", :with => 'This talk sounds really good so far. I\'d like to know if the presenter is going to cover some of the pain points that newbie sometimes feel when getting up and running, and how we might address those?'
      click_button 'Leave feedback'
    end

    i_am_on talk_path(@talk)
    within('#feedback #feedback_items .feedback:last-child') do
      assert page.has_content?('This talk sounds really good so far. I\'d like to know if the presenter is going to cover some of the pain points that newbie sometimes feel when getting up and running, and how we might address those?')
    end
  end

  def there_is_no_feedback_form
    assert page.has_no_field?('Feedback')
    assert page.has_no_button?('Leave feedback')
  end

  def there_is_a_feedback_form
    assert page.has_field?('Feedback')
    assert page.has_button?('Leave feedback')
  end
end