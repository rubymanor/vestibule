class Proposal < ActiveRecord::Base
  belongs_to :proposer, :class_name => 'User'
  has_many :suggestions

  validates :title, :presence => true

  scope :without_suggestions_from, lambda { |user|
    if user.suggestions.any?
      where('id NOT IN (?)', user.suggestions.map{ |s| s.proposal_id }.uniq)
    end
  }

  scope :not_proposed_by, lambda { |user|
    where('proposer_id != ?', user.id)
  }

  def last_modified
    new_suggestions.any? ? new_suggestions.maximum(:updated_at) : updated_at
  end

  def proposed_by?(user)
    proposer == user
  end

  def new_suggestions
    suggestions.after(self.updated_at)
  end
end
