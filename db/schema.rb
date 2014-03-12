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

ActiveRecord::Schema.define(version: 20140312191305) do

  create_table "matches", force: true do |t|
    t.string   "winner_key"
    t.string   "loser_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", id: false, force: true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mean"
    t.integer  "sigma"
    t.date     "last_tournament_date"
  end

  add_index "players", ["key"], name: "index_players_on_key", unique: true

end
