class Talk < ActiveRecord::Base
  belongs_to :proposer, :class_name => 'User'
end