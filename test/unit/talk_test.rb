require 'test_helper'

class TalkTest < ActiveSupport::TestCase
  context "a new talk" do
    setup do
      @talk = Factory.build(:talk)
    end

    should "be valid for saving" do
      assert @talk.save
    end

    should "require a title" do
      ['', nil].each do |missing_title|
        @talk.title = missing_title
        assert !@talk.valid?
        assert_not_nil @talk.errors['title']
      end
    end

    should 'require the talk to be more than 5 chars' do
      1.upto(4) do |i|
        @talk.title = ('a' * i)
        assert !@talk.valid?
        assert_not_nil @talk.errors['title']
      end
      @talk.title = ('a' * 5)
      assert @talk.valid?
    end

    should 'require the talk to be less than 300 chars' do
      @talk.title = ('a' * 299)
      assert @talk.valid?

      @talk.title = ('a' * 300)
      assert @talk.valid?

      @talk.title = ('a' * 301)
      assert !@talk.valid?
      assert_not_nil @talk.errors['title']
    end
  end
end
