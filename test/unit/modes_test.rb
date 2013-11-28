require 'test_helper'

class ModesTest < ActiveSupport::TestCase
  context "defining rulesets" do
    should "define a mode correctly" do
      modes = Modes.new
      modes.define do
        mode :test_mode
      end

      refute modes.rules(:test_mode).nil?
    end

    should "define a mode which acts like a Rules" do
      modes = Modes.new
      modes.define do
        mode :test_mode do
        end
      end

      assert modes.rules(:test_mode).respond_to?(:can?)
    end

    should "allow the Rules to define rules" do
      modes = Modes.new
      modes.define do
        mode :test_mode do
          can :see, :stuff
        end
      end

      assert modes.rules(:test_mode).can?(:see, :stuff)
    end
  end
end

