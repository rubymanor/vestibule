class Modes
  class NonExistentMode < StandardError; end

  attr_reader :rulesets

  def initialize()
    @rulesets = {}
  end

  def define(&block)
    DSL.new(self).define(&block) if block
    raise NonExistentMode, "mode #{@default.inspect} does not exist" if @default && !rules_for?(@default)
    nil
  end

  def rules(mode)
    rulesets.fetch(mode.to_sym, Modality::NoRules.new)
  end

  def rules_for?(mode)
    rulesets.has_key?(mode)
  end

  def clear!
    @rulesets = {}
  end

  def add_mode(name, rules)
    rulesets[name] = rules
  end

  def set_default(name)
    @default = name.to_sym
  end

  def default
    rules(@default)
  end

  class DSL
    def initialize(modes)
      @modes = modes
    end

    def define(&block)
      instance_exec(&block) if block
      @modes.set_default(@default) if @default
    end

    def default(name)
      @default = name.to_sym
    end

    def mode(name, &block)
      name = name.to_sym
      rules = Modality::Rules.new([], name)
      rules.define(&block) if block
      @modes.add_mode(name, rules)
      @default = name unless @default
      nil
    end
  end
end
