class CreateContributions < ActiveRecord::Migration
  def self.up
    create_table :contributions do |t|
      t.references :talk, :null => false
      t.references :user, :null => false
      t.string :kind, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :contributions
  end
end
