require 'test_helper'

class ModalityTest < ActiveSupport::TestCase
  context "creating the Rules" do
    should "report its mode name" do
      assert_equal :name, Modality.new(:name).mode
    end
  end

  context "defining rules" do
    should "define a rule correctly" do
      rules = Modality.new(:name)
      rules.define do
        can :see, :stuff
      end

      assert rules.can?(:see, :stuff)
    end

    should "not explode if the rules block has no rules" do
      rules = Modality.new(:name)
      rules.define

      refute rules.can?(:see, :stuff)
    end

    should "return nil from the define method" do
      rules = Modality.new(:name)
      assert_nil rules.define { can :see, :stuff }
    end
  end

  context "NoRules" do
    should "report that no-one can do anything" do
      refute Modality::NoRules.new.can?(:do, :something)
    end

    should "report its name" do
      assert_equal :no_rules, Modality::NoRules.new.mode
    end
  end
end
