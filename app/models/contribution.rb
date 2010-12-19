class Contribution < ActiveRecord::Base
  belongs_to :talk
  belongs_to :user

  validates :talk, :presence => true
  validates :kind, :inclusion => ['suggest', 'provide extra detail', 'discuss']
  validates :user_id, :presence => true,
                      :uniqueness => {:scope => [:talk_id, :kind], :message => 'only needs to be listed once per talk for a contribution type'}

  scope :discussions, where(:kind => 'discuss')
  scope :providing_extra_detail, where(:kind => 'provide extra detail')
  scope :suggestions, where(:kind => 'suggest')
  scope :by_user, lambda { |u| where(:user_id => u.id) }
end
