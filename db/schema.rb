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

ActiveRecord::Schema.define(version: 20170615193912) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", force: :cascade do |t|
    t.integer "home_user_id", null: false
    t.integer "away_user_id", null: false
    t.datetime "played_at"
    t.datetime "rejected_at"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_user_id"], name: "index_challenges_on_away_user_id"
    t.index ["game_id"], name: "index_challenges_on_game_id"
    t.index ["home_user_id"], name: "index_challenges_on_home_user_id"
  end

  create_table "elo_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "elo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_elo_histories_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "home_user_id", null: false
    t.integer "home_user_score", null: false
    t.integer "away_user_id", null: false
    t.integer "away_user_score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_user_id"], name: "index_games_on_away_user_id"
    t.index ["home_user_id"], name: "index_games_on_home_user_id"
  end

  create_table "live_games", force: :cascade do |t|
    t.integer "home_user_id"
    t.integer "away_user_id"
    t.integer "home_user_score", default: 0
    t.integer "away_user_score", default: 0
    t.boolean "current", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "elo", null: false
    t.string "tag_id"
    t.string "slack_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "challenges", "games"
  add_foreign_key "challenges", "users", column: "away_user_id"
  add_foreign_key "challenges", "users", column: "home_user_id"
  add_foreign_key "elo_histories", "users"
  add_foreign_key "games", "users", column: "away_user_id"
  add_foreign_key "games", "users", column: "home_user_id"
end
