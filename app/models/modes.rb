class Modes
  class NonExistentMode < StandardError; end

  attr_reader :config_file_path

  def initialize()
    @rule_sets = {}
  end

  def define(&block)
    instance_exec(&block) if block
    nil
  end

  def rules(mode)
    @rule_sets.fetch(mode.to_sym, Modality::NoRules.new)
  end

  def rules_for?(mode)
    @rule_sets.has_key?(mode)
  end

  def clear!
    @rule_sets = {}
  end

  def default(name = nil)
    if name.nil?
      raise NonExistentMode, "mode #{@default.inspect} does not exist" if @default && !rules_for?(@default)
      return rules(@default)
    end
    @default = name.to_sym
  end

  private

  def mode(name, &block)
    rules = Modality::Rules.new([])
    rules.define(&block) if block
    @rule_sets[name.to_sym] = rules
    @default = name.to_sym unless @default
    nil
  end
end
