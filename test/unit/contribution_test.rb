require 'test_helper'

class ContributionTest < ActiveSupport::TestCase
  context "a new contribution" do
    setup do
      @contribution = Factory.build(:contribution)
    end

    should "be valid for saving" do
      assert @contribution.save
    end

    should 'require a talk to be a contribution for' do
      @contribution.talk = nil
      assert !@contribution.valid?
      assert_not_nil @contribution.errors['talk']
    end

    should 'require a user that the contribution was made by' do
      @contribution.user = nil
      assert !@contribution.valid?
      assert_not_nil @contribution.errors['user']
    end

    should 'require a kind to say what sort of contribution it was' do
      [nil, ''].each do |missing_kind|
        @contribution.kind = missing_kind
        assert !@contribution.valid?
        assert_not_nil @contribution.errors['kind']
      end
    end

    should 'be valid if the kind is \'suggest\' or \'provide extra detail\'' do
      ['suggest', 'provide extra detail'].each do |valid_kind|
        @contribution.kind = valid_kind
        assert @contribution.valid?
      end
    end
    should 'not be valid if the kind is not \'suggest\' or \'provide extra detail\'' do
      ['provide_extra_detail', 'other kinds of contributions', '1234'].each do |invalid_kind|
        @contribution.kind = invalid_kind
        assert !@contribution.valid?
      end
    end
  end

  context "providing_extra_detail" do
    setup do
      @c1 = Factory.create(:contribution, :kind => 'provide extra detail')
      @c2 = Factory.create(:contribution, :kind => 'suggest')
      @c3 = Factory.create(:contribution, :kind => 'provide extra detail')
    end

    should 'not return any contributions that are of kind \'suggest\'' do
      assert !Contribution.providing_extra_detail.include?(@c2)
    end

    should 'return all contributions that are of kind \'provide extra detail\'' do
      assert Contribution.providing_extra_detail.include?(@c1)
      assert Contribution.providing_extra_detail.include?(@c3)
    end

    should 'be empty when there are no suggestions' do
      Contribution.delete_all(:kind => 'provide extra detail')
      assert_empty Contribution.providing_extra_detail
    end
  end

  context "suggestions" do
    setup do
      @c1 = Factory.create(:contribution, :kind => 'suggest')
      @c2 = Factory.create(:contribution, :kind => 'provide extra detail')
      @c3 = Factory.create(:contribution, :kind => 'suggest')
    end

    should 'not return any contributions that are of kind \'provide extra detail\'' do
      assert !Contribution.suggestions.include?(@c2)
    end

    should 'return all contributions that are of kind \'suggest\'' do
      assert Contribution.suggestions.include?(@c1)
      assert Contribution.suggestions.include?(@c3)
    end

    should 'be empty when there are no suggestions' do
      Contribution.delete_all(:kind => 'suggest')
      assert_empty Contribution.suggestions
    end
  end

  context "by_user" do
    setup do
      @u1 = Factory.create(:user)
      @u2 = Factory.create(:user)
      @u3 = Factory.create(:user)
      @c1 = Factory.create(:contribution, :user => @u1)
      @c2 = Factory.create(:contribution, :user => @u2)
      @c3 = Factory.create(:contribution, :user => @u1)
    end

    should 'not return contributions for different users' do
      assert !Contribution.by_user(@u1).include?(@c2)
    end

    should 'return all contributions for the given user' do
      assert Contribution.by_user(@u1).include?(@c1)
      assert Contribution.by_user(@u1).include?(@c3)
    end

    should 'be empty if the user has made no contributions' do
      assert_empty Contribution.by_user(@u3)
    end
  end
end
