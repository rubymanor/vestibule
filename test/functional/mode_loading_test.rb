require 'test_helper'
class ModeLoadingTest < ActionController::TestCase
  def self.i_can(do_a_thing, with_rule = nil)
    if with_rule.nil?
      should('be possible to '+do_a_thing)
    else
      should('be possible to '+do_a_thing) do
        assert @modality.can?(*with_rule), 'expected to be able to '+do_a_thing+', but I can\'t.'
      end
    end
  end

  def self.i_cant(do_a_thing, with_rule= nil)
    if with_rule.nil?
      should('not be possible to '+do_a_thing)
    else
      should('not be possible to '+do_a_thing) do
        refute @modality.can?(*with_rule), 'expected to not be able to '+do_a_thing+', but I can.'
      end
    end
  end

  context 'in cfp mode' do
    setup do
      @modality = Vestibule::Application.modes.fetch(:cfp)
    end

    i_can 'create a proposal', [:make, :proposal]
    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]

    i_cant 'participate in voting for proposals', [:make, :selection]
    i_cant 'see the aggregate votes', [:see, :agenda]
  end

  context 'in review mode' do
    setup do
      @modality = Vestibule::Application.modes.fetch(:review)
    end

    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]

    i_cant 'create a proposal', [:make, :proposal]
    i_cant 'participate in voting for proposals', [:make, :selection]
    i_cant 'see the aggregate votes', [:see, :agenda]
  end

  context 'in voting mode' do
    setup do
      @modality = Vestibule::Application.modes.fetch(:voting)
    end

    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]
    i_can 'participate in voting for proposals', [:make, :selection]
    i_can 'see my votes', [:see, :selection]

    i_cant 'create a proposal', [:create, :proposal]
    i_cant 'see the aggregate votes', [:see, :agenda]
  end

  context 'in holding mode' do
    setup do
      @modality = Vestibule::Application.modes.fetch(:holding)
    end

    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]
    i_can 'see my votes', [:see, :selection]

    i_cant 'participate in voting for proposals', [:make, :selection]
    i_cant 'see the aggregate votes', [:see, :agenda]
    i_cant 'create a proposal', [:make, :proposal]
  end

  context 'in agenda mode' do
    setup do
      @modality = Vestibule::Application.modes.fetch(:agenda)
    end

    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]
    i_can 'see the aggregate votes', [:see, :agenda]
    i_can 'see my votes', [:see, :selection]

    i_cant 'participate in voting for proposals', [:make, :selection]
    i_cant 'create a proposal', [:make, :proposal]
  end

  context 'in archive mode' do
    setup do
      @modality = Vestibule::Application.modes.fetch(:archive)
    end

    i_can 'see the aggregate votes', [:see, :agenda]
    i_can 'see my votes', [:see, :selection]

    i_cant 'create a proposal', [:make, :proposal]
    i_cant 'make a suggestion on a proposal', [:make, :suggestion]
    i_cant 'change my proposal', [:change, :proposal]
    i_cant 'withdraw my proposal', [:withdraw, :proposal]
    i_cant 'participate in voting for proposals', [:make, :selection]
  end
end
