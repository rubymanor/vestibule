module Vestibule
  def self.mode_of_operation
    @mode_of_operation ||= Vestibule::Application.modes.fetch(ENV['VESTIBULE_MODE'])
  end
  def self.mode_of_operation=(new_mode)
    @mode_of_operation =
      if new_mode.respond_to?(:can?)
        new_mode
      else
        Vestibule::Application.modes.fetch(new_mode)
      end
  end
end
