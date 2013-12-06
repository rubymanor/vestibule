module ModeHelper
  def user_can(action, object, &block)
    return "" unless current_user.known? && can?(action, object)
    capture(&block)
  end

  def anyone_can(action, object, &block)
    return "" unless can?(action, object)
    capture(&block)
  end

  def anonymous_can(action, object, &block)
    return "" unless current_user.anonymous? && can?(action, object)
    capture(&block)
  end

  def user_cannot(action, object, &block)
    return "" unless current_user.known? && !can?(action, object)
    capture(&block)
  end

  def no_one_can(action, object, &block)
    return "" if can?(action, object)
    capture(&block)
  end

  def anonymous_cannot(action, object, &block)
    return "" unless current_user.anonymous? && !can?(action, object)
    capture(&block)
  end
end
