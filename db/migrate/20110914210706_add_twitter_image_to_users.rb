class AddTwitterImageToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_image, :string
  end

  def self.down
    remove_column :users, :twitter_image
  end
end
