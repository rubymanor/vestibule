class ScortchedEarth < ActiveRecord::Migration
  def self.up
    create_table :proposals, :force => true do |t|
      t.string     :title
      t.timestamps
      t.references :proposer
      t.text       :description
    end

    create_table :suggestions, :force => true do |t|
      t.text       :body
      t.references :author
      t.references :proposal
      t.timestamps
    end

    create_table :users, :force => true do |t|
      t.text       :signup_reason
      t.timestamps
      t.string     :name
      t.string     :twitter_uid
      t.string     :twitter_nickname
    end
  end

  def self.down
    drop_table :users
    drop_table :suggestions
    drop_table :proposals
  end
end
