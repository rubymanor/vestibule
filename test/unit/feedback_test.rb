require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  context "a new bit of feedback for a talk" do
    setup do
      @feedback = Factory.build(:feedback)
    end

    should "be valid for saving" do
      assert @feedback.save
    end

    should "require a user to have left the feedback" do
      @feedback.user = nil
      assert !@feedback.valid?
      assert_not_nil @feedback.errors['user']
    end

    should "require a talk to provide feedback on" do
      @feedback.talk = nil
      assert !@feedback.valid?
      assert_not_nil @feedback.errors['talk']
    end

    should "require the content to be present" do
      ['', nil].each do |missing_content|
        @feedback.content = missing_content
        assert !@feedback.valid?
        assert_not_nil @feedback.errors['content']
      end
    end

    should 'require the content to be more than 5 chars' do
      1.upto(4) do |i|
        @feedback.content = ('a' * i)
        assert !@feedback.valid?
        assert_not_nil @feedback.errors['content']
      end
      @feedback.content = ('a' * 5)
      assert @feedback.valid?
    end
  end
end
