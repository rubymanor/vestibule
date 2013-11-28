require 'test_helper'
class ModeLoadingTest < ActionController::TestCase
  def self.i_can(do_a_thing, with_rule = nil)
    if with_rule.nil?
      should('be possible to '+do_a_thing)
    else
      should('be possible to '+do_a_thing) do
        assert @rules.can?(*with_rule), 'expected to be able to '+do_a_thing+', but I can\'t.'
      end
    end
  end

  def self.i_cant(do_a_thing, with_rule= nil)
    if with_rule.nil?
      should('not be possible to '+do_a_thing)
    else
      should('not be possible to '+do_a_thing) do
        refute @rules.can?(*with_rule), 'expected to not be able to '+do_a_thing+', but I can.'
      end
    end
  end

  context 'the cfp mode' do
    setup do
      @rules = Vestibule::Application.modes.rules(:cfp)
    end

    i_can 'create a proposal', [:make, :proposal]
    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]

    i_cant 'participate in voting for proposals', [:make, :selection]
    i_cant 'see the aggregate votes', [:see, :agenda]
  end
end
