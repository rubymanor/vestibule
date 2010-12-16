class Contribution < ActiveRecord::Base
  belongs_to :talk
  belongs_to :user

  validates :talk, :user, :presence => true
  validates :kind, :inclusion => ['suggest', 'provide extra detail']

  scope :providing_extra_detail, where(:kind => 'provide extra detail')
  scope :suggestions, where(:kind => 'suggest')
  scope :by_user, lambda { |u| where(:user_id => u.id) }
end
