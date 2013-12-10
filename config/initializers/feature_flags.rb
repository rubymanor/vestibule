require 'feature_flag'

class ActionDispatch::Routing::Mapper
  include FeatureFlag
end
