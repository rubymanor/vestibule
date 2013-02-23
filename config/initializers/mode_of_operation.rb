module Vestibule
  def self.mode_of_operation
    @mode_of_operation ||= Modality.new()
  end
  def self.mode_of_operation=(new_mode)
    @mode_of_operation =
      if new_mode.is_a? Modality
        new_mode
      else
        Modality.new(new_mode)
      end
  end
end
Vestibule.mode_of_operation = ENV['VESTIBULE_MODE']