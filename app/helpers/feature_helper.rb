module FeatureHelper
  def feature(name, &block)
    result = ""
    if Vestibule::Application.config.features[name.to_sym]
      result = capture(&block)
    end
    result
  end
end
