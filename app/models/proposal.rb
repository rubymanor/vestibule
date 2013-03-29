class Proposal < ActiveRecord::Base
  belongs_to :proposer, :class_name => 'User'
  has_many :suggestions

  acts_as_voteable

  validates :title, :presence => true

  # This allows us to do @proposal.impression_count
  # and other stuff from the 'impressionist' gem.
  is_impressionable counter_cache: { column_name: :impressions_counter_cache }

  scope :without_suggestions_from, lambda { |user|
    if user.suggestions.any?
      where('id NOT IN (?)', user.suggestions.map{ |s| s.proposal_id }.uniq)
    end
  }

  scope :without_votes_from, lambda { |user|
    voted_by_user = user.votes.where(voteable_type: 'Proposal')
    if voted_by_user.any?
      where('id NOT IN (?)', voted_by_user.map{ |s| s.voteable_id }.uniq)
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

  def new_suggestions
    suggestions.after(last_modified_by_proposer)
  end

  def published?
    !withdrawn
  end

  def withdraw!
    update_attribute(:withdrawn, true)
  end

  def republish!
    update_attribute(:withdrawn, false)
  end

  private

  def last_modified_by_proposer
    [suggestions.by(proposer).maximum(:updated_at), updated_at].compact.max
  end

  def update_proposer_score
    proposer.save
  end
end
