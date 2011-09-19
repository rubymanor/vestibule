class AddContributionScore < ActiveRecord::Migration
  def self.up
    add_column :users, :contribution_score, :integer
    User.all.each { |u| u.save }
  end

  def self.down
    remove_column :users, :contribution_score
  end
end