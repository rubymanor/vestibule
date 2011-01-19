class RenameTalksToProposals < ActiveRecord::Migration
  def self.up
    rename_table :talks, :proposals
  end

  def self.down
    rename_table :proposals, :talks
  end
end