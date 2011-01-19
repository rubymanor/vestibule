class Suggestion < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :proposal

  validates :body, :presence => true
end
