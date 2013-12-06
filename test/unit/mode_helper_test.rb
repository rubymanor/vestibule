require 'test_helper'
class ModeHelperTest < ActionView::TestCase
  include ModeHelper

  # this is pretty horrid
  def current_user
    @current_user
  end

  # this is almost unspeakably horrid
  # def can?(*args)
  #   ApplicationController.new.send(:can?, *args)
  # end

  context "anyone_can" do
    should "render its block for a mode operation which is enabled for everyone" do
      Vestibule.mode_of_operation = :agenda

      assert_equal "a", anyone_can(:see, :agenda) { "a" }
    end

    should "not render its block for a mode operation which is not enabled for everyone" do
      Vestibule.mode_of_operation = :cfp

      assert_equal "", anyone_can(:see, :agenda) { "a" }
    end
  end

  context "no_one_can" do
    should "render its block for a mode operation which is disabled for everyone" do
      Vestibule.mode_of_operation = :cfp

      assert_equal "a", no_one_can(:see, :agenda) { "a" }
    end

    should "not render its block for a mode operation which is not disabled for everyone" do
      Vestibule.mode_of_operation = :agenda

      assert_equal "", no_one_can(:see, :agenda) { "a" }
    end
  end

  context "with user" do
    setup do
      @current_user = User.new
    end

    context "user_can" do
      should "render its block for a mode operation which is enabled for users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", user_can(:make, :proposal) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", user_can(:make, :selection) { "a" }
      end
    end

    context "user_cannot" do
      should "render its block for a mode operation which is disabled for users" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "a", user_cannot(:make, :proposal) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", user_cannot(:make, :proposal) { "a" }
      end
    end
  end

  context "with anonymous user" do
    setup do
      @current_user = AnonymousUser.new
    end

    context "anonymous_can" do
      should "render its block for a mode operation which is enabled for anonymous users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", anonymous_can(:make, :proposal) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for anonymous users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "", anonymous_can(:make, :selection) { "a" }
      end
    end

    context "anonymous_cannot" do
      should "render its block for a mode operation which is disabled for anonymous users" do
        Vestibule.mode_of_operation = :cfp

        assert_equal "a", anonymous_cannot(:see, :agenda) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for anonymous users" do
        Vestibule.mode_of_operation = :agenda

        assert_equal "", anonymous_cannot(:see, :agenda) { "a" }
      end
    end
  end
end
