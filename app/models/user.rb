class User < ActiveRecord::Base
  has_many :proposals, :foreign_key => :proposer_id
  has_many :suggestions, :foreign_key => :author_id
  has_many :proposals_of_interest, :through => :suggestions, :source => :proposal, :uniq => true

  def proposals_you_should_look_at
    Proposal.without_suggestions_from(self).not_proposed_by(self)
  end

  def proposals_that_have_changed
    proposals_of_interest.not_proposed_by(self).select { |p| p.updated_at > p.suggestions.by(self).latest.first.updated_at }
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["user_info"]["name"]
      user.twitter_uid = auth["uid"]
      user.twitter_nickname = auth["user_info"]["nickname"]
    end
  end

  def to_param
    twitter_nickname
  end
end
