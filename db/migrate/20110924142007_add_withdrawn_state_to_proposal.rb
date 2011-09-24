class AddWithdrawnStateToProposal < ActiveRecord::Migration
  def self.up
    add_column :proposals, :withdrawn, :boolean, :default => false
  end

  def self.down
    remove_column :proposals, :withdrawn
  end
end