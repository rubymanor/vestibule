class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.text :signup_reason
      t.integer :account_id
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end