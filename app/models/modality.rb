class Modality
  MODES = %w(cfp review voting agenda archive)
  attr_reader :mode
  def initialize(mode = :cfp)
    @mode =
      if MODES.include? mode.to_s
        mode.to_s.to_sym
      else
        :cfp
      end
  end

  def can?(action, object)
    rules.can?(action, object)
  end

  class Rules
    attr_reader :ruleset
    def initialize(ruleset)
      @ruleset = ruleset
    end
    def request_to_rule(action, object)
      [action.to_sym, object.to_sym]
    end
    def can?(action, object)
      rule = request_to_rule(action, object)
      ruleset.include?(rule)
    end
  end

  class NoRules
    def can?(action, object)
      false
    end
  end

  def self.make_rules_for_ruleset(*rules)
    Modality::Rules.new(rules)
  end

  CfpRules = make_rules_for_ruleset(
    [:make, :proposal],
    [:change, :proposal],
    [:make, :suggestion],
    [:withdraw, :proposal]
  )

  ReviewRules = make_rules_for_ruleset(
    [:change, :proposal],
    [:make, :suggestion],
    [:withdraw, :proposal]
  )

  VotingRules = make_rules_for_ruleset(
    [:change, :proposal],
    [:make, :suggestion],
    [:withdraw, :proposal],
    [:make, :selection],
  )

  AgendaRules = make_rules_for_ruleset(
    [:change, :proposal],
    [:make, :suggestion],
    [:withdraw, :proposal],
    [:see, :agenda]
  )

  ArchiveRules = make_rules_for_ruleset(
    [:see, :agenda]
  )

  RULES = {
    cfp: CfpRules,
    review: ReviewRules,
    voting: VotingRules,
    agenda: AgendaRules,
    archive: ArchiveRules
  }
  def rules
    RULES.fetch(mode, NoRules)
  end

end