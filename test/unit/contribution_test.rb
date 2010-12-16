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
end
