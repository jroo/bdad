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

ActiveRecord::Schema.define(:version => 20100615212837) do

  create_table "cd110", :primary_key => "gid", :force => true do |t|
    t.string        "state",      :limit => 2
    t.string        "cd",         :limit => 2
    t.string        "lsad",       :limit => 2
    t.string        "name",       :limit => 90
    t.string        "lsad_trans", :limit => 50
    t.multi_polygon "the_geom",   :limit => nil
  end

  create_table "districts", :force => true do |t|
    t.string   "state"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "screen_datas", :force => true do |t|
    t.text     "value"
    t.string   "token",      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sketches", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "screen_data"
    t.geometry "map_data",    :limit => nil
    t.string   "token",       :limit => 40
  end

  create_table "states", :primary_key => "gid", :force => true do |t|
    t.decimal       "area"
    t.decimal       "perimeter"
    t.integer       "st99_d00_",  :limit => 8
    t.integer       "st99_d00_i", :limit => 8
    t.string        "state",      :limit => 2
    t.string        "name",       :limit => 90
    t.string        "lsad",       :limit => 2
    t.string        "region",     :limit => 1
    t.string        "division",   :limit => 1
    t.string        "lsad_trans", :limit => 50
    t.multi_polygon "the_geom",   :limit => nil
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
