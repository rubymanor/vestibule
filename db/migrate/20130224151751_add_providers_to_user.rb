class AddProvidersToUser < ActiveRecord::Migration
  def change
    ## Twitter
    add_column :users, :twitter_uid,      :string
    add_column :users, :twitter_nickname, :string

    ## Facebook
    add_column :users, :facebook_uid,      :string
    add_column :users, :facebook_nickname, :string

    ## Google
    add_column :users, :google_uid,        :string
    add_column :users, :google_nickname,   :string
  end
end
