module FeatureRouting
  def feature(name, &block)
    if Vestibule::Application.config.features[name]
      instance_exec(&block)
    end
  end
end
