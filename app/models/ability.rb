class Ability
  include CanCan::Ability

  # See the wiki for how to define abilities:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    user ||= User.new

    # Everyone
    can :see, :index
    can :see, :motivation
    can :create, :session
    can :read, User
    can :read, Proposal

    # Registered users
    if user.persisted?
      can :destroy, :session

      can :see, :dashboard
      can :see, :my_motivation
      can [:update], User, :id => user.id

      can [:update, :create, :withdraw, :republish], Proposal, :proposer_id => user.id

      can [:create], Suggestion, :author_id => user.id
      can [:vote], Proposal
      cannot [:vote], Proposal, :proposer_id => user.id
    end
  end
end
