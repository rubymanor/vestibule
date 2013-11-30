require 'test_helper'

class ModalityTest < ActiveSupport::TestCase
  context "creating the Modality" do
    should "report its mode name" do
      assert_equal :name, Modality.new(:name).mode
    end
  end

  context "defining modality with the DSL" do
    should "define a rule correctly" do
      modality = Modality::DSL.define(:name) do
        can :see, :stuff
      end

      assert modality.can?(:see, :stuff)
    end

    should "not explode if the modality block has no rules" do
      modality = Modality::DSL.define(:name)

      refute modality.can?(:see, :stuff)
    end

    should "return nil from the can method" do
      result = true
      Modality::DSL.define(:name) do
        result = can(:see, :stuff)
      end
      assert_nil result
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
