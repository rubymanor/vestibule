# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130315135423) do

  create_table "proposals", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "proposer_id"
    t.text     "description"
    t.boolean  "withdrawn",   :default => false
    t.boolean  "confirmed",   :default => false, :null => false
  end

  create_table "selections", :force => true do |t|
    t.integer "proposal_id"
    t.integer "user_id"
  end

  create_table "suggestions", :force => true do |t|
    t.text     "body"
    t.integer  "author_id"
    t.integer  "proposal_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.text     "signup_reason"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "name"
    t.integer  "contribution_score"
    t.string   "github_uid"
    t.string   "github_nickname"
    t.string   "email"
  end

end
