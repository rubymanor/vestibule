class Suggestion < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :proposal

  scope :by, lambda { |user| where(:author_id => user) }
  scope :latest, order('updated_at DESC')
  scope :after, lambda { |timestamp| where('updated_at > ?', timestamp) }

  validates :body, :presence => true
  validate :is_a_meaningful_contribution

  after_create :update_author_score

  private

  def is_a_meaningful_contribution
    if %w(+1 -1).include?(body.strip)
      errors["body"] << "should contain some concrete suggestions about how to develop this proposal"
    elsif body.length < 50
      errors["body"] << "should be a meaningful contribution or criticism (i.e. at least 50 characters)"
    end
  end

  def update_author_score
    author.save
  end
end
