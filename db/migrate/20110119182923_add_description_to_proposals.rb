class AddDescriptionToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :description, :text
  end

  def self.down
    remove_column :proposals, :description
  end
end
