class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :talk

  validates :user, :presence => true
  validates :talk, :presence => true
  validates :content, :presence => true, :length => {:minimum => 5}
end
