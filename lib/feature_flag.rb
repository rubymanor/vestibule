require 'active_support/concern'

module FeatureFlag
  extend ActiveSupport::Concern

  def self.can?(action, object)
    Vestibule.mode_of_operation.can?(action, object)
  end

  def can?(*args)
    FeatureFlag.can?(*args)
  end

  def anyone_can(action, object, &block)
    instance_exec(&block) if can?(action, object)
  end

  def no_one_can(action, object, &block)
    instance_exec(&block) if !can?(action, object)
  end

  module ClassMethods
    def can?(*args)
      FeatureFlag.can?(*args)
    end

    def anyone_can(action, object, &block)
      class_exec(&block) if can?(action, object)
    end

    def no_one_can(action, object, &block)
      class_exec(&block) if !can?(action, object)
    end
  end
end
