require "test_helper"

class SelectionTest < IntegrationTestCase

  context "Given a bunch of proposals" do
    setup do
      @destroy_ruby = FactoryGirl.create(:proposal, :title => "Destroy Ruby")
      @hot_gem = FactoryGirl.create(:proposal, :title => "My Hot New Gem")
      @merb = FactoryGirl.create(:proposal, :title => "I Miss Merb")
    end

    context "a logged in user" do
      setup do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context 'when the app is in cfp mode' do
        setup { Vestibule.mode_of_operation = :cfp }

        should 'not see a menu item for selections or agenda' do
          visit '/'
          within 'header' do
            refute page.has_link?('Selections')
            refute page.has_link?('Agenda')
          end
        end

        should 'not see a call to action on their dashboard asking them to make selections' do
          visit '/'
          within '#content' do
            refute page.has_link?('Choose the talks you want to see on the day')
          end
        end

        should 'not be able to make any selections' do
          visit selections_path
          i_am_alerted 'In cfp mode you cannot vote for proposals'
        end
      end

      context 'when the app is in voting mode' do
        setup { Vestibule.mode_of_operation = :voting }

        should 'see a menu item for selections' do
          visit '/'
          within 'header' do
            assert page.has_link?('Selections')
          end
        end

        should 'not see a menu item for the agenda' do
          visit '/'
          within 'header' do
            refute page.has_link?('Agenda')
          end
        end

        should 'see a call to action on their dashboard asking them to make selections' do
          visit '/'
          within '#content' do
            assert page.has_link?('choose the talks you want to see on the day')
          end
        end

        should "be able to select their preferred proposals" do
          visit "/"
          click_link "Selections"
          select_proposal "Destroy Ruby"
          select_proposal "I Miss Merb"
          assert page.has_css?("#selections a", :text => "Destroy Ruby")
          assert page.has_css?("#selections a", :text => "I Miss Merb")
          assert page.has_no_css?("#selections a", :text => "My Hot New Gem")
        end

        should "only be able to select 8 proposals" do
          proposals = (1..8).to_a.map { FactoryGirl.create(:proposal) }
          visit "/"
          click_link "Selections"
          8.times { |x| select_proposal proposals[x].title }
          select_proposal "Destroy Ruby"
          i_am_alerted "You can only select 8 proposals at a time"
        end

        context "having selected some proposals" do
          setup do
            visit "/"
            click_link "Selections"
            select_proposal "Destroy Ruby"
          end

          should "be able to deselect them" do
            deselect_proposal "Destroy Ruby"
            assert page.has_no_css?("#selections a", :text => "Destroy Ruby")
          end

          should 'not be able to see the agenda calculated from all selections' do
            assert page.has_no_css?('#the_chosen_ones')
          end
        end
      end

      context 'when the app is in agenda mode' do
        setup { Vestibule.mode_of_operation = :agenda }

        should 'not see a menu item for selections' do
          visit '/'
          within 'header' do
            refute page.has_link?('Selections')
          end
        end

        should 'see a menu item for the agenda' do
          visit '/'
          within 'header' do
            assert page.has_link?('Agenda')
          end
        end

        should 'not see a call to action on their dashboard asking them to make selections' do
          visit '/'
          within '#content' do
            refute page.has_link?('choose the talks you want to see on the day')
          end
        end

        should 'see a call to action on their dashboard suggesting they look at the community selected agenda' do
          visit '/'
          within '#content' do
            assert page.has_link?('take a look at the agenda they have generated')
          end
        end

        context 'having selected some proposals' do
          setup do
            Selection.create(proposal: @destroy_ruby, user: @user)
            Selection.create(proposal: @merb, user: @user)
          end

          should "be able to see the community agenda" do
            visit selections_path
            assert page.has_css?('#the_chosen_ones')
          end

          should 'be able to see their own selections' do
            visit selections_path
            within '#selections' do
              assert page.has_link?("Destroy Ruby")
              assert page.has_link?("I Miss Merb")
              assert page.has_no_link?("My Hot New Gem")
            end
          end

          should 'not be able to change their own selections' do
            visit selections_path
            within '#selections' do
              assert page.has_no_button?('Deselect')
            end
            assert page.has_no_css?('#available_selections')
          end
        end
      end

      context 'when the app is in archive mode' do
        setup { Vestibule.mode_of_operation = :archive }

        should 'not see a menu item for selections' do
          visit '/'
          within 'header' do
            refute page.has_link?('Selections')
          end
        end

        should 'see a menu item for the agenda' do
          visit '/'
          within 'header' do
            assert page.has_link?('Agenda')
          end
        end

        should 'not see a call to action on their dashboard asking them to make selections' do
          visit '/'
          within '#content' do
            refute page.has_link?('choose the talks you want to see on the day')
          end
        end

        should 'see a call to action on their dashboard suggesting they look at the community selected agenda' do
          visit '/'
          within '#content' do
            assert page.has_link?('take a look at the agenda they have generated')
          end
        end

        context 'having selected some proposals' do
          setup do
            Selection.create(proposal: @destroy_ruby, user: @user)
            Selection.create(proposal: @merb, user: @user)
          end

          should "be able to see the community agenda" do
            visit selections_path
            assert page.has_css?('#the_chosen_ones')
          end

          should 'be able to see their own selections' do
            visit selections_path
            within '#selections' do
              assert page.has_link?("Destroy Ruby")
              assert page.has_link?("I Miss Merb")
              assert page.has_no_link?("My Hot New Gem")
            end
          end

          should 'not be able to change their own selections' do
            visit selections_path
            within '#selections' do
              assert page.has_no_button?('Deselect')
            end
            assert page.has_no_css?('#available_selections')
          end
        end
      end
    end
  end
end