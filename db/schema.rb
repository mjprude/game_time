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

ActiveRecord::Schema.define(version: 20141109221146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hangmen", force: :cascade do |t|
    t.string   "word",        limit: 255
    t.string   "latlng",      limit: 255
    t.string   "game_state",  limit: 255
    t.string   "bad_guesses", limit: 255, default: ""
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ttt_games", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "user_sym",   limit: 255
    t.integer  "ttt_id"
    t.boolean  "turn",                   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ttts", force: :cascade do |t|
    t.boolean  "game_over",              default: false
    t.string   "game_state", limit: 255, default: "         "
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",       limit: 255,             null: false
    t.string   "password_hash",  limit: 255
    t.string   "avatar",         limit: 255
    t.string   "age",            limit: 255
    t.integer  "hangman_wins",               default: 0
    t.integer  "hangman_losses",             default: 0
    t.integer  "ttt_wins",                   default: 0
    t.integer  "ttt_losses",                 default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
