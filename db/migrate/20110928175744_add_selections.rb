class AddSelections < ActiveRecord::Migration
  def self.up
    create_table :selections, :force => true do |t|
      t.integer :proposal_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :selections
  end
end