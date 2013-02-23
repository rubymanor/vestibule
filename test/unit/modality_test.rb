require 'test_helper'

class ModalityTest < ActiveSupport::TestCase
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

  context 'setting the mode' do
    should 'take a string' do
      m = Modality.new('cfp')
      assert_equal :cfp, m.mode
    end
    should 'take a symbol' do
      m = Modality.new(:cfp)
      assert_equal :cfp, m.mode
    end
    should 'treat "cfp", "voting", "agenda", "archive" as valid modes' do
      ["cfp", "voting", "agenda", "archive"].each do |mode|
        m = Modality.new(mode)
        assert_equal mode.to_sym, m.mode
      end
    end
    should 'be cfp if not told otherwise' do
      m = Modality.new
      assert_equal :cfp, m.mode
    end
    should 'treat nil as cfp' do
      m = Modality.new(nil)
      assert_equal :cfp, m.mode
    end
    should 'treat any unrecognized mode as cfp' do
      ['meh', '', 1, {}, []].each do |unknown_mode|
        m = Modality.new(unknown_mode)
        assert_equal :cfp, m.mode
      end
    end
  end

  context 'in cfp mode' do
    setup do
      @modality = Modality.new(:cfp)
    end
    i_can 'create a proposal', [:make, :proposal]
    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]

    i_cant 'participate in voting for proposals', [:make, :selection]
    i_cant 'see the aggregate votes', [:see, :agenda]
  end

  context 'in voting mode' do
    setup do
      @modality = Modality.new(:voting)
    end
    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]
    i_can 'participate in voting for proposals', [:make, :selection]

    i_cant 'create a proposal', [:create, :proposal]
    i_cant 'see the aggregate votes', [:see, :agenda]
  end

  context 'in agenda mode' do
    setup do
      @modality = Modality.new(:agenda)
    end
    i_can 'make a suggestion on a proposal', [:make, :suggestion]
    i_can 'change my proposal', [:change, :proposal]
    i_can 'withdraw my proposal', [:withdraw, :proposal]
    i_can 'see the aggregate votes', [:see, :agenda]

    i_cant 'participate in voting for proposals', [:make, :selection]
    i_cant 'create a proposal', [:make, :proposal]
  end

  context 'in archive mode' do
    setup do
      @modality = Modality.new(:archive)
    end
    i_can 'see the aggregate votes', [:see, :agenda]

    i_cant 'create a proposal', [:make, :proposal]
    i_cant 'make a suggestion on a proposal', [:make, :suggestion]
    i_cant 'change my proposal', [:change, :proposal]
    i_cant 'withdraw my proposal', [:withdraw, :proposal]
    i_cant 'participate in voting for proposals', [:make, :selection]
  end

end
