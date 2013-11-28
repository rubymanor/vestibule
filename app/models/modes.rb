class Modes
  attr_reader :config_file_path

  def initialize()
    @rule_sets = {}
  end

  def define(&block)
    instance_exec(&block)
  end

  def rules(mode)
    @rule_sets[mode]
  end

  private

  def mode(name, &block)
    rules = Modality::Rules.new([])
    rules.define(&block)
    @rule_sets[name] = rules
  end
end
