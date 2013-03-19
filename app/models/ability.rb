class Ability
  include CanCan::Ability

  # See the wiki for how to define abilities:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    user ||= User.new

    # Everyone
    can :read, User

    # Registered users
    if user.persisted?
      can [:update], User, :id => user.id
    end
  end
end
