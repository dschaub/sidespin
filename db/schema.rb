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

ActiveRecord::Schema.define(version: 20150602011428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_scores", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "user_id", null: false
    t.integer "score",   null: false
    t.integer "rank",    null: false
  end

  add_index "game_scores", ["game_id", "user_id"], name: "index_game_scores_on_game_id_and_user_id", unique: true, using: :btree
  add_index "game_scores", ["game_id"], name: "index_game_scores_on_game_id", using: :btree
  add_index "game_scores", ["user_id"], name: "index_game_scores_on_user_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "match_id",   null: false
    t.integer  "sequence",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["match_id"], name: "index_games_on_match_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "created_by_user_id", null: false
    t.datetime "held_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ball_color"
    t.string   "ball_quality"
  end

  add_index "matches", ["created_by_user_id"], name: "index_matches_on_created_by_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username",                            null: false
    t.string   "display_name"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "game_scores", "games"
  add_foreign_key "game_scores", "users"
  add_foreign_key "games", "matches"
  add_foreign_key "matches", "users", column: "created_by_user_id"
end
