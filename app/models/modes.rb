class Modes
  class NonExistentMode < StandardError; end

  attr_reader :modalities

  def initialize()
    @modalities = {}
  end

  def define(&block)
    DSL.new(self).define(&block) if block
    raise NonExistentMode, "mode #{@default.inspect} does not exist" if @default && !modality_for?(@default)
    nil
  end

  def fetch(name)
    return default unless name.respond_to?(:to_sym)
    modalities.fetch(name.to_sym) { default }
  end

  def modality_for?(name)
    modalities.has_key?(name)
  end

  def clear!
    @modalities = {}
  end

  def add_mode(name, modality)
    modalities[name] = modality
  end

  def set_default(name)
    @default = name.to_sym
  end

  def default
    return Modality::NoRules.new unless modality_for?(@default)
    fetch(@default)
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
      modality = Modality.new(name)
      modality.define(&block) if block
      @modes.add_mode(name, modality)
      @default = name unless @default
      nil
    end
  end
end
