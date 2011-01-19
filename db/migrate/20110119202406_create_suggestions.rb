class CreateSuggestions < ActiveRecord::Migration
  def self.up
    create_table :suggestions do |t|
      t.text :body
      t.references :author
      t.references :proposal

      t.timestamps
    end
  end

  def self.down
    drop_table :suggestions
  end
end
