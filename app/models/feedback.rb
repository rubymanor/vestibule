class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :talk

  attr_accessible :content

  validates :user, :presence => true
  validates :talk, :presence => true
  validates :content, :presence => true, :length => {:minimum => 5}

  after_create :add_user_as_discusser_to_talk

  protected
  def add_user_as_discusser_to_talk
    talk.add_discusser!(user)
  end
end
