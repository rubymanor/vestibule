class User < ActiveRecord::Base
  belongs_to :account
  has_many :proposals, :foreign_key => :proposer_id
  has_many :suggestions, :foreign_key => :author_id
  validates_presence_of :account_id

  delegate :email, :to => :account
end
