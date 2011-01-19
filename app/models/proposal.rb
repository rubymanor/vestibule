class Proposal < ActiveRecord::Base
  belongs_to :proposer, :class_name => 'User'
end