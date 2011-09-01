class RemoveAccountIdFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :account_id
  end

  def self.down
    add_column :users, :account_id, :integer
  end
end
