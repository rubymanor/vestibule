require 'test_helper'
require 'feature_flag'

class FeatureFlagTest < ActiveSupport::TestCase
  context "within class definition or routing" do
    setup do
      @klass_proc = Proc.new {
        include FeatureFlag
        anyone_can :see, :agenda do
          def anyone
          end
        end

        no_one_can :see, :agenda do
          def noone
          end
        end
      }
    end

    context "anyone_can" do
      should "define a method if anyone can perform the action on the object" do
        Vestibule.mode_of_operation = :agenda
        klass = Class.new(&@klass_proc)

        assert klass.new.respond_to?(:anyone)
      end

      should "not define a method if a no-one can perform the action on the object" do
        Vestibule.mode_of_operation = :cfp
        klass = Class.new(&@klass_proc)

        refute klass.new.respond_to?(:anyone)
      end
    end

    context "no_one_can" do
      should "define a method if no-one can perform the action on the object" do
        Vestibule.mode_of_operation = :cfp
        klass = Class.new(&@klass_proc)

        assert klass.new.respond_to?(:noone)
      end

      should "not define a method if anyone can perform the action on the object" do
        Vestibule.mode_of_operation = :agenda
        klass = Class.new(&@klass_proc)

        refute klass.new.respond_to?(:noone)
      end
    end

    context "within a method" do
      setup do
        klass = Class.new do
          include FeatureFlag
          def anyone
            result = false
            anyone_can(:see, :agenda) { result = true }
            result
          end

          def noone
            result = false
            no_one_can(:see, :agenda) { result = true }
            result
          end
        end
        @obj = klass.new
      end

      context "anyone_can" do
        should "execute code if anyone can perform the action on the object" do
          Vestibule.mode_of_operation = :agenda

          assert @obj.anyone
        end

        should "not execute code if no-one can perform the action on the object" do
          Vestibule.mode_of_operation = :cfp

          refute @obj.anyone
        end
      end

      context "no_one_can" do
        should "execute code if no-one can perform the action on the object" do
          Vestibule.mode_of_operation = :cfp

          assert @obj.noone
        end

        should "not execute code if anyone can perform the action on the object" do
          Vestibule.mode_of_operation = :agenda

          refute @obj.noone
        end
      end
    end
  end
end
