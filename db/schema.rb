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

ActiveRecord::Schema.define(version: 20180203130926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "usd_rate", precision: 9, scale: 4
    t.index ["name"], name: "index_currencies_on_name"
  end

  create_table "discounts", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "store_id", null: false
    t.decimal "from_price", precision: 8, scale: 2, null: false
    t.decimal "to_price", precision: 8, scale: 2, null: false
    t.decimal "from_price_usd", precision: 8, scale: 2
    t.decimal "to_price_usd", precision: 8, scale: 2
    t.boolean "was_tweeted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "usd_value", precision: 8, scale: 2
    t.index ["created_at"], name: "index_discounts_on_created_at"
    t.index ["product_id"], name: "index_discounts_on_product_id"
    t.index ["store_id"], name: "index_discounts_on_store_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "store_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.decimal "base_price", precision: 8, scale: 2, null: false
    t.decimal "current_price", precision: 8, scale: 2
    t.string "currency", null: false
    t.string "icon_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "base_price_formatted", null: false
    t.string "current_price_formatted", null: false
    t.string "store_country", null: false
    t.string "app_url"
    t.decimal "lowest_price", precision: 8, scale: 2
    t.float "average_user_rating", default: 0.0, null: false
    t.integer "user_rating_count", default: 0, null: false
    t.integer "discount_ratio", default: 0, null: false
    t.string "slug"
    t.string "big_icon_url"
    t.index ["average_user_rating", "user_rating_count"], name: "index_products_on_average_user_rating_and_user_rating_count"
    t.index ["slug"], name: "index_products_on_slug"
    t.index ["user_id", "store_id"], name: "index_products_on_user_id_and_store_id", unique: true
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token", limit: 64, null: false
    t.datetime "failed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token", limit: 64
    t.string "sound", default: "default"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false
    t.text "notification"
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "users", force: :cascade do |t|
    t.string "auth_token", null: false
    t.string "device_token", null: false
    t.datetime "last_active", null: false
    t.string "device_push_token"
    t.string "timezone", null: false
    t.boolean "sandbox", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "store_country"
    t.boolean "is_pro", default: false, null: false
    t.index ["auth_token", "device_token"], name: "index_users_on_auth_token_and_device_token", unique: true
  end

  add_foreign_key "products", "users"
end
