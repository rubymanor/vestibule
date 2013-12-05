class User < ActiveRecord::Base
  has_many :proposals, :foreign_key => :proposer_id
  has_many :suggestions, :foreign_key => :author_id
  has_many :proposals_of_interest, :through => :suggestions, :source => :proposal, :uniq => true
  has_many :selections

  scope :with_signup_reasons, where("signup_reason IS NOT NULL")
  scope :without_signup_reasons, where(:signup_reason => nil)
  scope :by_contribution, order("contribution_score DESC")

  before_save :update_contribution_score

  TWITTER_USERS_PER_REQUEST = 100

  def proposals_you_should_look_at
    Proposal.active.in_modification_order.without_suggestions_from(self).not_proposed_by(self).all
  end

  def proposals_that_have_changed
    proposals_of_interest.active.not_proposed_by(self).in_modification_order.select { |p| p.updated_at > p.suggestions.by(self).maximum(:updated_at) }
  end

  def proposals_that_have_been_withdrawn
    proposals_of_interest.withdrawn.in_modification_order.all
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["info"]["name"] || auth['info']['nickname']
      user.github_uid = auth["uid"]
      user.github_nickname = auth["info"]["nickname"]
      user.email = auth["info"]["email"]
    end
  end

  def to_param
    github_nickname
  end

  REASON_WEIGHT = 5
  SUGGESTION_WEIGHT = 2

  def proposals_with_interest
    proposals.select { |p| p.suggestions.any? }
  end

  def update_contribution_score
    self.contribution_score = (suggestions.not_on_proposals_by(self).count * SUGGESTION_WEIGHT)
    self.contribution_score += REASON_WEIGHT if self.signup_reason.present?
  end

  def anonymous?
    false
  end

  def known?
    true
  end
end
