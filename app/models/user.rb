class User < ActiveRecord::Base
  has_many :proposals, :foreign_key => :proposer_id
  has_many :suggestions, :foreign_key => :author_id
  has_many :proposals_of_interest, :through => :suggestions, :source => :proposal, :uniq => true

  scope :with_signup_reasons, where("signup_reason IS NOT NULL")
  scope :without_signup_reasons, where(:signup_reason => nil)

  TWITTER_USERS_PER_REQUEST = 100

  def proposals_you_should_look_at
    Proposal.without_suggestions_from(self).not_proposed_by(self)
  end

  def proposals_that_have_changed
    proposals_of_interest.not_proposed_by(self).select { |p| p.updated_at > p.suggestions.by(self).maximum(:updated_at) }
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["user_info"]["name"]
      user.twitter_uid = auth["uid"]
      user.twitter_nickname = auth["user_info"]["nickname"]
      user.twitter_image = auth["user_info"]["image"]
    end
  end

  def self.update_twitter_images
    all.map { |user| user.twitter_uid.to_i }.each_slice(TWITTER_USERS_PER_REQUEST) do |uids|
      Twitter.users(uids).each do |twitter_user|
        if (user = find_by_twitter_uid(twitter_user.id.to_s)).present? && (twitter_image = twitter_user.profile_image_url).present?
          user.update_attributes :twitter_image => twitter_image
        end
      end
    end
  end

  def to_param
    twitter_nickname
  end
end
