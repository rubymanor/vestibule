Vestibule::Application.modes.define do
  mode :cfp do
    can :make, :proposal
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
  end

  mode :review do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
  end

  mode :voting do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :make, :selection
    can :see, :selection
  end

  mode :holding do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :see, :selection
  end

  mode :agenda do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :see, :selection
    can :see, :agenda
  end

  mode :archive do
    can :see, :agenda
    can :see, :selection
  end

  default :cfp
end
