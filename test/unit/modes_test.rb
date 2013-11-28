require 'test_helper'

class ModesTest < ActiveSupport::TestCase
  context "defining rulesets" do
    should "define a mode correctly" do
      modes = Modes.new
      modes.define do
        mode :test_mode do
        end
      end

      refute modes.rules(:test_mode).nil?
    end
  end
end

