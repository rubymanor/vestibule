class Selection < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :user

  validates_presence_of :proposal_id, :user_id
  validate :limited_number_of_selections_per_user

  def self.limit_per_user
    8
  end

  def self.popular
    Selection.includes(:proposal).group_by(&:proposal).sort_by do |_, selections|
      -selections.size
    end.map do |proposal, selections|
      [selections.size, proposal]
    end
  end

  private

  def limited_number_of_selections_per_user
    if Selection.where(user_id: user.id).count >= self.class.limit_per_user
      errors.add(:base, "You can only select 8 proposals at a time")
    end
  end
end