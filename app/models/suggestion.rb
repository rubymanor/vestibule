class Suggestion < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :proposal

  scope :by, lambda { |user| where(:author_id => user) }
  scope :latest, order('updated_at DESC')
  scope :after, lambda { |timestamp| where('updated_at > ?', timestamp) }

  validates :body, :presence => true
  validate :not_a_plus_one

  private

  def not_a_plus_one
    if %w(+1 -1).include?(body.strip)
      errors["body"] << "should contain some concrete suggestions about how to develop this proposal"
    end
  end
end
