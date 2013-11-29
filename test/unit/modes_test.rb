require 'test_helper'

class ModesTest < ActiveSupport::TestCase
  context "defining modes" do
    setup do
      @modes = Modes.new
    end

    should "define a mode correctly" do
      @modes.define do
        mode :test_mode
      end

      refute @modes.fetch(:test_mode).nil?
    end

    should "set the name of the mode correctly" do
      @modes.define do
        mode :test_mode
      end

      assert_equal :test_mode, @modes.fetch(:test_mode).mode
    end

    should "define a mode which acts like a Modality" do
      @modes.define do
        mode :test_mode do
        end
      end

      assert @modes.fetch(:test_mode).respond_to?(:can?)
    end

    should "allow the Modality to define rules" do
      @modes.define do
        mode :test_mode do
          can :see, :stuff
        end
      end

      assert @modes.fetch(:test_mode).can?(:see, :stuff)
    end

    should "allow the definition of multiple modes" do
      @modes.define do
        mode :m1 do
          can :see, :stuff
        end

        mode :m2 do
          can :do, :stuff
        end
      end

      assert @modes.fetch(:m1).can?(:see, :stuff)
      assert @modes.fetch(:m2).can?(:do, :stuff)
    end

    should "return nil from the define method" do
      assert_nil @modes.define { mode :test_mode }
    end

    should "not explode if no block is passed" do
      assert_nil @modes.define
    end

    should "normalise the input to #mode" do
      @modes.define { mode("test_mode") { can(:see, :stuff) } }

      assert @modes.fetch(:test_mode).can?(:see, :stuff)
    end

    should "normalise the input to #fetch" do
      @modes.define { mode(:test_mode) { can(:see, :stuff) } }

      assert @modes.fetch("test_mode").can?(:see, :stuff)
    end

    should "return NoRules if asked for a non-existing rule set" do
      refute @modes.fetch(:test_mode).can?(:see, :stuff)
    end

    context "default mode" do
      should "allow a default to be set" do
        @modes.define do
          mode(:m1) { can(:see, :stuff) }
          mode(:m2) { can(:do, :stuff) }

          default :m2
        end
        assert @modes.default.can?(:do, :stuff)
      end

      should "set the first-defined mode as default if it's not explicit" do
        @modes.define do
          mode(:m1) { can(:see, :stuff) }
          mode(:m2) { can(:do, :stuff) }
        end
        assert @modes.default.can?(:see, :stuff)
      end

      should "allow the default to be set before the mode is defined" do
        @modes.define do
          default :m2

          mode(:m1) { can(:see, :stuff) }
          mode(:m2) { can(:do, :stuff) }
        end
        assert @modes.default.can?(:do, :stuff)
      end

      should "explode if an explicit but non-existent default is set" do
        assert_raises(Modes::NonExistentMode) {
          @modes.define do
            default :test_mode
          end
        }
      end
    end
  end

  context "fetching a Modality" do
    setup do
      @modes = Modes.new
    end

    context "with defined modes" do
      should 'treat any unrecognized mode as the default' do
        @modes.define do
          mode(:test_mode) { can(:see, :stuff) }
          default :test_mode
        end
        ['meh', '', 1, {}, [], nil].each do |unknown_mode|
          assert_equal :test_mode, @modes.fetch(unknown_mode).mode
        end
      end
    end

    context "without defined modes" do
      should 'treat any unrecognized mode as NoRules' do
        ['meh', '', 1, {}, [], nil].each do |unknown_mode|
          assert Modality::NoRules === @modes.fetch(unknown_mode)
        end
      end
    end
  end

  should "support clear! so that it can be safely reloaded" do
    modes = Modes.new
    modes.define { mode(:test_mode) { can(:see, :stuff) } }
    modes.clear!
    refute modes.fetch(:test_mode).can?(:see, :stuff)
  end
end

