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

    should 'require the title to be more than 5 chars' do
      1.upto(4) do |i|
        @talk.title = ('a' * i)
        assert !@talk.valid?
        assert_not_nil @talk.errors['title']
      end
      @talk.title = ('a' * 5)
      assert @talk.valid?
    end

    should 'require the title to be less than 300 chars' do
      @talk.title = ('a' * 299)
      assert @talk.valid?

      @talk.title = ('a' * 300)
      assert @talk.valid?

      @talk.title = ('a' * 301)
      assert !@talk.valid?
      assert_not_nil @talk.errors['title']
    end

    [:abstract, :outline, :why_its_interesting].each do |optional_text_attribute|
      should "not require the #{optional_text_attribute} to be present" do
        ['', nil].each do |missing_value|
          @talk.send(:"#{optional_text_attribute}=", missing_value)
          assert @talk.valid?
        end
      end

      should "require the #{optional_text_attribute} (if present) to be more than 10 chars" do
        1.upto(9) do |i|
          @talk.send(:"#{optional_text_attribute}=", ('a' * i))
          assert !@talk.valid?
          assert_not_nil @talk.errors[optional_text_attribute.to_s]
        end
        @talk.send(:"#{optional_text_attribute}=", ('a' * 10))
        assert @talk.valid?
      end
    end
  end
end
