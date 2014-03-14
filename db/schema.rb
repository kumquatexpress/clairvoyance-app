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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140314032939) do

  create_table "champions", force: true do |t|
    t.string   "image"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "compatibility_id"
    t.string   "types",            default: ""
  end

  create_table "champions_games", id: false, force: true do |t|
    t.integer "game_id"
    t.integer "champion_id"
  end

  add_index "champions_games", ["champion_id"], name: "champion_id_ix", using: :btree
  add_index "champions_games", ["game_id"], name: "game_id_ix", using: :btree

  create_table "compatibilities", force: true do |t|
    t.integer  "champion_id"
    t.string   "compat",      limit: 5000, default: "--- {}\n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "type"
    t.datetime "date"
    t.integer  "win"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processed",  default: false
  end

  create_table "games_items", id: false, force: true do |t|
    t.integer "game_id"
    t.integer "item_id"
  end

  add_index "games_items", ["game_id"], name: "game_id_ix", using: :btree
  add_index "games_items", ["item_id"], name: "item_id_ix", using: :btree

  create_table "games_team_comps", id: false, force: true do |t|
    t.integer "game_id",      limit: 8
    t.integer "team_comp_id", limit: 8
  end

  add_index "games_team_comps", ["game_id"], name: "game_id_ix", using: :btree
  add_index "games_team_comps", ["team_comp_id"], name: "team_id_ix", using: :btree

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_comps", id: false, force: true do |t|
    t.string   "id"
    t.integer  "c1"
    t.integer  "c2"
    t.integer  "c3"
    t.integer  "c4"
    t.integer  "c5"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
