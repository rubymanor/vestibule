class UseGravatarIdRatherThanGithubImage < ActiveRecord::Migration
  def change
    remove_column :users, :github_image
  end
end
