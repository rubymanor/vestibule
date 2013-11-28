class Modes
  attr_reader :config_file_path

  def initialize()
    @rules = {}
  end

  def define(&block)
    instance_exec(&block) if block_given?
  end

  def rules(mode)
    @rules[mode]
  end

  private

  def mode(name, &block)
    @rules[name] = Modality::Rules.new([])
  end
end
