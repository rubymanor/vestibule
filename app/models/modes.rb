class Modes
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

  def clear!
    @rule_sets = {}
  end

  private

  def mode(name, &block)
    rules = Modality::Rules.new([])
    rules.define(&block) if block
    @rule_sets[name.to_sym] = rules
  end
end
