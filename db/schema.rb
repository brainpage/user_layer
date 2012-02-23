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

ActiveRecord::Schema.define(:version => 20120221012335) do

  create_table "app_lists", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps", :force => true do |t|
    t.integer  "care_id"
    t.integer  "app_list_id"
    t.string   "app_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cares", :force => true do |t|
    t.integer  "owner_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "app_id"
    t.string   "event_id"
    t.text     "event"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mobile_devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.string   "name"
    t.string   "platform"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mobile_devices", ["user_id"], :name => "index_mobile_devices_on_user_id"
  add_index "mobile_devices", ["uuid"], :name => "index_mobile_devices_on_uuid"

  create_table "sensors", :force => true do |t|
    t.string   "stype"
    t.string   "uid"
    t.string   "description"
    t.boolean  "public"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
