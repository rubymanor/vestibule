require 'test_helper'

class RulesTest < ActiveSupport::TestCase
  context "defining rules" do
    should "define a rule correctly" do
      rules = Modality::Rules.new([])
      rules.define do
        can :see, :stuff
      end

      assert rules.can?(:see, :stuff)
    end
  end
end
