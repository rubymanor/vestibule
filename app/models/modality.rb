class Modality
  class NoRules
    def can?(action, object)
      false
    end

    def mode
      :no_rules
    end
  end

  attr_reader :ruleset, :mode

  def initialize(name)
    @ruleset = []
    @mode = name
  end

  def add_rule(action, object)
    @ruleset << [action, object]
  end

  def request_to_rule(action, object)
    [action.to_sym, object.to_sym]
  end

  def can?(action, object)
    rule = request_to_rule(action, object)
    ruleset.include?(rule)
  end

  class DSL
    def self.define(name, &block)
      modality = Modality.new(name)
      new(modality, block)
      modality
    end

    def initialize(modality, block)
      @modality = modality
      instance_exec(&block) if block
    end

    def can(action, object)
      @modality.add_rule(action, object)
      nil
    end
  end
end
