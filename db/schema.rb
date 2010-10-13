# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100224034525) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", :force => true do |t|
    t.string  "csv_file_name"
    t.string  "csv_content_type"
    t.integer "csv_file_size"
    t.integer "num_imported",     :default => 0
  end

  create_table "invitees", :force => true do |t|
    t.string   "name",                                :null => false
    t.boolean  "coming",           :default => false, :null => false
    t.boolean  "is_kid",           :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "need_babysitter",  :default => false, :null => false
    t.integer  "login_id",         :default => 0
    t.boolean  "is_primary",       :default => false, :null => false
    t.boolean  "rehearsal_coming", :default => false, :null => false
  end

  create_table "logins", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "rehearsal_invited", :default => false, :null => false
  end

  create_table "responses", :force => true do |t|
    t.integer  "vegetarian",       :default => 0, :null => false
    t.integer  "vegan",            :default => 0, :null => false
    t.integer  "gluten_free",      :default => 0, :null => false
    t.integer  "nut_allergy",      :default => 0, :null => false
    t.string   "other_food_issue"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "login_id",         :default => 0
  end

end
