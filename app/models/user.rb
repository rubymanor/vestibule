class User < ActiveRecord::Base
  belongs_to :account
  has_many :proposals, :foreign_key => :proposer_id
  has_many :suggestions, :foreign_key => :author_id
  has_many :proposals_of_interest, :through => :suggestions, :source => :proposal, :uniq => true

  validates_presence_of :account_id

  delegate :email, :to => :account

  def proposals_you_should_look_at
    Proposal.without_suggestions_from(self).not_proposed_by(self)
  end

  def proposals_that_have_changed
    proposals_of_interest.select { |p| p.updated_at > p.suggestions.by(self).latest.first.updated_at }
  end
end
