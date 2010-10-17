class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts, :force => true do |t|
      t.text :signup_reason
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end