class Account < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_one :user
  delegate :proposals, :suggestions, :to => :user
  delegate :proposals_you_should_look_at, :proposals_that_have_changed, :to => :user

  after_create :create_user
end