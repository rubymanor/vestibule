class CreateTalks < ActiveRecord::Migration
  def self.up
    create_table :talks do |t|
      t.string :title, :limit => 300, :null => false
      t.text :abstract
      t.text :outline
      t.text :why_its_interesting

      t.timestamps
    end
  end

  def self.down
    drop_table :talks
  end
end
