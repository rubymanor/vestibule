class Modality
  class NoRules
    def can?(action, object)
      false
    end
  end

  attr_reader :ruleset, :mode
  def initialize(ruleset, mode = nil)
    @ruleset = ruleset
    @mode = mode
  end
  def request_to_rule(action, object)
    [action.to_sym, object.to_sym]
  end
  def can?(action, object)
    rule = request_to_rule(action, object)
    ruleset.include?(rule)
  end

  def define(&block)
    instance_exec(&block) if block
    nil
  end

  private

  def can(action, object)
    @ruleset << [action, object]
  end

end
