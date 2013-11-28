Vestibule::Application.modes.define do
  mode :cfp do
    can :make, :proposal
    can :change, :proposal
    can :make, :suggestion
    can :withdraw, :proposal
  end
end
