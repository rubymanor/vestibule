class ChangeAuthToGithub < ActiveRecord::Migration
  def change
    [:uid, :nickname, :image].each do |column|
      remove_column :users, :"twitter_#{column}"
      add_column :users, :"github_#{column}", :string
    end
  end
end
