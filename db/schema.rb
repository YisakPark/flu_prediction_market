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

ActiveRecord::Schema.define(version: 2018_07_18_112538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "shares"
  end

  create_table "line_shares", force: :cascade do |t|
    t.decimal "quantity", precision: 10, scale: 4
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "building"
    t.decimal "flu_population_rate", precision: 5, scale: 4
    t.index ["user_id"], name: "index_line_shares_on_user_id"
  end

  create_table "market_status", force: :cascade do |t|
    t.string "date_market"
    t.string "building"
    t.decimal "flu_population_rate", precision: 5, scale: 4
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "isDone", default: false
    t.decimal "quantity", precision: 10, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_type"
    t.decimal "cost", precision: 10, scale: 4
    t.string "date_market"
    t.string "building"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "past_prices", force: :cascade do |t|
    t.string "building"
    t.string "date_market"
  end

  create_table "queue_classic_jobs", force: :cascade do |t|
    t.text "q_name", null: false
    t.text "method", null: false
    t.json "args", null: false
    t.datetime "locked_at"
    t.integer "locked_by"
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "scheduled_at", default: -> { "now()" }
    t.index ["q_name", "id"], name: "idx_qc_on_name_only_unlocked", where: "(locked_at IS NULL)"
    t.index ["scheduled_at", "id"], name: "idx_qc_on_scheduled_at_only_unlocked", where: "(locked_at IS NULL)"
  end

  create_table "shares", force: :cascade do |t|
    t.decimal "sell_price"
    t.decimal "buy_price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "share_quantity", default: 0
    t.decimal "money", precision: 10, scale: 4, default: "100.0"
    t.boolean "admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "line_shares", "users"
end
