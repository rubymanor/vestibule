require 'test_helper'

class AnonymousUserTest < ActiveSupport::TestCase
  setup do
    @anon = AnonymousUser.new
  end

  should "assert its anonymity" do
    assert @anon.anonymous?
  end

  should "not claim to be known" do
    refute @anon.known?
  end
end
