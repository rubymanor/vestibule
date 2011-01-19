class Account < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_one :user
  delegate :talks, :to => :user

  after_create :create_user

  protected
  def create_user
    User.create!(:account_id => self.id)
  end
end