require 'test_helper'

class TalkTest < ActiveSupport::TestCase
  context "a new talk" do
    setup do
      @talk = Factory.build(:talk)
    end

    should "be valid for saving" do
      assert @talk.save
    end

    should "have no feedback yet" do
      assert @talk.feedbacks.empty?
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

    should 'require an original suggester' do
      @talk.suggester = nil
      assert !@talk.valid?
      assert_not_nil @talk.errors['suggester']
    end
  end

  should 'list the suggester as one of the contributors' do
    talk = Factory.create(:talk)
    assert talk.contributors.include?(talk.suggester)
  end

  context "add_extra_detail_provider" do
    setup do
      @talk = Factory.create(:talk)
      @user = Factory.create(:user)
    end

    should "build a new contribution of the kind 'provide extra detail' to the talk for the user" do
      new_extra_detail_provider = @talk.add_extra_detail_provider(@user)
      assert_not_nil new_extra_detail_provider
      assert new_extra_detail_provider.new_record?
      assert_equal @user, new_extra_detail_provider.user
      assert_equal 'provide extra detail', new_extra_detail_provider.kind
      assert_not_nil @talk.contributions.detect { |c| c == new_extra_detail_provider }
    end

    should "create a new contribution of the kind 'provide extra detail' to the talk for the user when called with a bang" do
      @talk.add_extra_detail_provider!(@user)
      assert_not_nil @talk.contributions.select { |c| c.user == @user && c.kind = 'provide extra detail' && !c.new_record? }
    end

    should "not build a new contribution when the user is already an extra detail provider" do
      @talk.add_extra_detail_provider!(@user)
      assert_nil @talk.add_extra_detail_provider(@user)
      assert_equal 1, @talk.contributions.select { |c| c.user == @user && c.kind = 'provide extra detail' }.size
    end

    should "not create a new contribution when the user is already an extra detail provider" do
      @talk.add_extra_detail_provider!(@user)
      @talk.add_extra_detail_provider!(@user)
      assert_equal 1, @talk.contributions.select { |c| c.user == @user && c.kind = 'provide extra detail' }.size
    end
  end

  context "add_discusser" do
    setup do
      @talk = Factory.create(:talk)
      @user = Factory.create(:user)
    end

    should "build a new contribution of the kind 'discuss' to the talk for the user" do
      new_discusser = @talk.add_discusser(@user)
      assert_not_nil new_discusser
      assert new_discusser.new_record?
      assert_equal @user, new_discusser.user
      assert_equal 'discuss', new_discusser.kind
      assert_not_nil @talk.contributions.detect { |c| c == new_discusser }
    end

    should "create a new contribution of the kind 'discuss' to the talk for the user when called with a bang" do
      @talk.add_discusser!(@user)
      assert_not_nil @talk.contributions.select { |c| c.user == @user && c.kind = 'discuss' && !c.new_record? }
    end

    should "not build a new contribution when the user is already a discusser" do
      @talk.add_discusser!(@user)
      assert_nil @talk.add_discusser(@user)
      assert_equal 1, @talk.contributions.select { |c| c.user == @user && c.kind = 'discuss' }.size
    end

    should "not create a new contribution when the user is already a discusser" do
      @talk.add_discusser!(@user)
      @talk.add_discusser!(@user)
      assert_equal 1, @talk.contributions.select { |c| c.user == @user && c.kind = 'discuss' }.size
    end
  end
end
