class Proposal < ActiveRecord::Base
  belongs_to :proposer, :class_name => 'User'
  has_many :suggestions
  has_many :rankings, :class_name => 'AgendaItem'
  has_many :rankers, :through => :rankings, :source => :user
  validates :title, :presence => true

  scope :without_suggestions_from, lambda { |user|
    if user.suggestions.any?
      where('id NOT IN (?)', user.suggestions.map{ |s| s.proposal_id }.uniq)
    end
  }

  scope :not_proposed_by, lambda { |user|
    where('proposer_id != ?', user.id)
  }

  scope :active, where(withdrawn: false)
  scope :withdrawn, where(withdrawn: true)

  after_create :update_proposer_score

  def last_modified
    new_suggestions.any? ? new_suggestions.maximum(:updated_at) : last_modified_by_proposer
  end

  def proposed_by?(user)
    proposer == user
  end

  def ranked_by?(user)
    rankers.include?(user)
  end

  def new_suggestions
    suggestions.after(last_modified_by_proposer)
  end

  def withdraw!
    update_attribute(:withdrawn, true)
  end

  private

  def last_modified_by_proposer
    [suggestions.by(proposer).maximum(:updated_at), updated_at].compact.max
  end

  def update_proposer_score
    proposer.save
  end
end
