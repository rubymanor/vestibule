Vestibule::Application.modes.define do
  mode :cfp do
    can :make, :proposal
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :add, :motivation
    can :see, :motivation
  end

  mode :review do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :add, :motivation
    can :see, :motivation
  end

  mode :voting do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :make, :selection
    can :see, :selection
    can :add, :motivation
    can :see, :motivation
  end

  mode :holding do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :see, :selection
    can :add, :motivation
    can :see, :motivation
  end

  mode :agenda do
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
    can :see, :selection
    can :see, :agenda
    can :see, :motivation
    can :add, :motivation
  end

  mode :archive do
    can :see, :agenda
    can :see, :selection
    can :see, :motivation
  end

  default :cfp
end
