require 'feature_flag'

module ModeHelper
  include FeatureFlag
  def anyone_can(action, object, &block)
    return "" unless can?(action, object)
    capture(&block)
  end

  def no_one_can(action, object, &block)
    return "" if can?(action, object)
    capture(&block)
  end

  def user_can(action, object, &block)
    return "" unless current_user.known?
    anyone_can(action, object, &block)
  end

  def user_cannot(action, object, &block)
    return "" unless current_user.known?
    no_one_can(action, object, &block)
  end

  def anonymous_can(action, object, &block)
    return "" unless current_user.anonymous?
    anyone_can(action, object, &block)
  end

  def anonymous_cannot(action, object, &block)
    return "" unless current_user.anonymous?
    no_one_can(action, object, &block)
  end
end
