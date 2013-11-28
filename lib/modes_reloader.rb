require "active_support/core_ext/module/delegation"

class ModesReloader
  attr_reader :mode_sets, :paths
  delegate :execute_if_updated, :execute, :updated?, to: :updater

  def initialize(path, modes)
    @paths      = [path]
    @mode_sets = [modes]
  end

  def reload!
    clear!
    load_paths
  end

  private

  def updater
    @updater ||= begin
      updater = ActiveSupport::FileUpdateChecker.new(paths) { reload! }
      updater.execute
      updater
    end
  end

  def clear!
    mode_sets.each do |modes|
      modes.clear!
    end
  end

  def load_paths
    paths.each { |path| load(path) }
  end
end

