require 'test_helper'

class ModalityTest < ActiveSupport::TestCase
  context "creating the Modality" do
    should "report its mode name" do
      assert_equal :name, Modality.new(:name).mode
    end
  end

  context "defining modality" do
    should "define a rule correctly" do
      modality = Modality.new(:name)
      modality.define do
        can :see, :stuff
      end

      assert modality.can?(:see, :stuff)
    end

    should "not explode if the modality block has no rules" do
      modality = Modality.new(:name)
      modality.define

      refute modality.can?(:see, :stuff)
    end

    should "return nil from the define method" do
      modality = Modality.new(:name)
      assert_nil modality.define { can :see, :stuff }
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
