require 'test_helper'

class RoutingFeatureTest < ActionController::TestCase
  should "set a route for a switched-on feature" do
    Vestibule.mode_of_operation = :cfp
    with_routing do |set|
      set.draw do
        anyone_can :make, :proposal do
          resources :users
        end
      end
      assert_routing "/users", controller: 'users', action: 'index'
    end
  end

  should "not set a route for a switched-off feature" do
    Vestibule::Application.config.features.test_feature = false
    with_routing do |set|
      set.draw do
        anyone_can :see, :agenda do
          resources :users
        end
      end
      assert_raise(ActionController::RoutingError) do
        assert_routing "/users", controller: 'users', action: 'index'
      end
    end
  end
end
