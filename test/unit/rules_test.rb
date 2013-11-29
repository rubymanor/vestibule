require 'test_helper'

class RulesTest < ActiveSupport::TestCase
  context "creating the Rules" do
    should "report its mode name" do
      assert_equal :name, Modality::Rules.new([], :name).mode
    end
  end

  context "defining rules" do
    should "define a rule correctly" do
      rules = Modality::Rules.new([], :name)
      rules.define do
        can :see, :stuff
      end

      assert rules.can?(:see, :stuff)
    end

    should "not explode if the rules block has no rules" do
      rules = Modality::Rules.new([], :name)
      rules.define

      refute rules.can?(:see, :stuff)
    end

    should "return nil from the define method" do
      rules = Modality::Rules.new([], :name)
      assert_nil rules.define { can :see, :stuff }
    end
  end
end
