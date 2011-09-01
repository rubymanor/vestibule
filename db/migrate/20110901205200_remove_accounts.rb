class RemoveAccounts < ActiveRecord::Migration
  def self.up
    drop_table :accounts
  end

  def self.down
    create_table "accounts", :force => true do |t|
      t.string   "email",                               :default => "", :null => false
      t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
      t.string   "password_salt",                       :default => "", :null => false
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                       :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
