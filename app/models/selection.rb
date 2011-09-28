class Selection < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :user

  validates_presence_of :proposal_id, :user_id
end