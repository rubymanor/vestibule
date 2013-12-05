require 'test_helper'
class ModeHelperTest < ActionView::TestCase
  include ModeHelper

  # this is pretty horrid
  def current_user
    @current_user
  end

  # this is almost unspeakably horrid
  def can?(*args)
    ApplicationController.new.send(:can?, *args)
  end

  context "with a signed-in user" do
    setup do
      @current_user = User.new
    end

    context "enabling" do
      should "render its block for a mode operation which is enabled for users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", user_can(:make, :proposal) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", user_can(:make, :selection) { "a" }
      end

      should "render its block for a mode operation which is enabled for everyone" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "a", anyone_can(:see, :agenda) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for everyone" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", anyone_can(:see, :agenda) { "a" }
      end
    end

    context "disabling" do
      should "render its block for a mode operation which is disabled for users" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "a", user_cannot(:make, :proposal) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", user_cannot(:make, :proposal) { "a" }
      end

      should "render its block for a mode operation which is disabled for everyone" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", anyone_cannot(:see, :agenda) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for everyone" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "", anyone_cannot(:see, :agenda) { "a" }
      end
    end
  end

  context "with an anonymous user" do
    setup do
      @current_user = AnonymousUser.new
    end

    context "enabled" do
      should "render its block for a mode operation which is enabled for anonymous users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", anonymous_can(:make, :proposal) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for anonymous users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", anonymous_can(:make, :selection) { "a" }
      end

      should "render its block for a mode operation which is enabled for everyone" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "a", anyone_can(:see, :agenda) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for everyone" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", anyone_can(:see, :agenda) { "a" }
      end
    end

    context "disabled" do
      should "render its block for a mode operation which is disabled for anonymous users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", anonymous_cannot(:see, :agenda) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for anonymous users" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "", anonymous_cannot(:see, :agenda) { "a" }
      end

      should "render its block for a mode operation which is disabled for everyone" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", anyone_cannot(:see, :agenda) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for everyone" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "", anyone_cannot(:see, :agenda) { "a" }
      end
    end
  end
end
