class AddProposerToTalks < ActiveRecord::Migration
  def self.up
    change_table :talks do |t|
      t.references :proposer
    end
  end

  def self.down
    change_table :table_name do |t|
      t.remove_references :proposer
    end
  end
end