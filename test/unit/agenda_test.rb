require 'test_helper'

class AgendaTest < ActiveSupport::TestCase
  context "An agenda" do
    setup do
      @agenda = Factory(:agenda)
    end

    should "be valid" do
      assert @agenda.valid?
    end

    context "fetching proposals" do
      setup do
        to_create = [["third", 3], ["second", 2], ["first", 1]]
        to_create.each do |pair|
          new_item = Factory.create(:agenda_item,
                                    :proposal => Factory.create(:proposal, :description => pair[0]),
                                    :rank => pair[1])
          @agenda.agenda_items << new_item
        end
      end

      should "list them in ranked order" do
        assert_equal(["first", "second", "third"], @agenda.proposals.map(&:description))
      end
    end
  end
end
