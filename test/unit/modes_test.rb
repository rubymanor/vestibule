require 'test_helper'

class ModesTest < ActiveSupport::TestCase
  context "defining rulesets" do
    setup do
      @modes = Modes.new
    end
    should "define a mode correctly" do
      @modes.define do
        mode :test_mode
      end

      refute @modes.rules(:test_mode).nil?
    end

    should "define a mode which acts like a Rules" do
      @modes.define do
        mode :test_mode do
        end
      end

      assert @modes.rules(:test_mode).respond_to?(:can?)
    end

    should "allow the Rules to define rules" do
      @modes.define do
        mode :test_mode do
          can :see, :stuff
        end
      end

      assert @modes.rules(:test_mode).can?(:see, :stuff)
    end

    should "return nil from the define method" do
      assert_nil @modes.define { mode :test_mode }
    end

    should "not explode if no block is passed" do
      assert_nil @modes.define
    end

    should "normalise the input to #mode" do
      @modes.define { mode("test_mode") { can(:see, :stuff) } }

      assert @modes.rules(:test_mode).can?(:see, :stuff)
    end

    should "normalise the input to #rules" do
      @modes.define { mode(:test_mode) { can(:see, :stuff) } }

      assert @modes.rules("test_mode").can?(:see, :stuff)
    end

    should "return NoRules if asked for a non-existing rule set" do
      refute @modes.rules(:test_mode).can?(:see, :stuff)
    end
  end
end

