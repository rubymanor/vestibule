class Contribution < ActiveRecord::Base
  belongs_to :talk
  belongs_to :user

  validates :talk, :user, :presence => true
  validates :kind, :inclusion => ['suggest', 'provide extra detail']
end
