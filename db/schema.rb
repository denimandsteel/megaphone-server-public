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

ActiveRecord::Schema.define(version: 20160531174655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.string   "full_name",              default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.boolean  "manager",                default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "created_by_id"
  end

  add_index "administrators", ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true, using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "payment_token"
    t.string   "api_token"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "enable_notifications"
    t.boolean  "enable_location"
    t.string   "last_four_digits"
    t.string   "push_notification_token"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "city"
    t.string   "neighbourhood"
    t.string   "cross_street"
    t.string   "hours"
    t.integer  "vendor_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "locations", ["vendor_id"], name: "index_locations_on_vendor_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "paid_by_id"
    t.integer  "vendor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "payments", ["vendor_id"], name: "index_payments_on_vendor_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "price"
    t.text     "description"
    t.string   "title"
    t.boolean  "in_app"
    t.string   "image"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "category"
    t.integer  "order"
    t.datetime "last_notification_date"
  end

  create_table "products_vendors", force: :cascade do |t|
    t.integer "product_id"
    t.integer "vendor_id"
  end

  add_index "products_vendors", ["product_id"], name: "index_products_vendors_on_product_id", using: :btree
  add_index "products_vendors", ["vendor_id"], name: "index_products_vendors_on_vendor_id", using: :btree

  create_table "purchase_products", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "purchase_id"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "purchase_products", ["product_id"], name: "index_purchase_products_on_product_id", using: :btree
  add_index "purchase_products", ["purchase_id"], name: "index_purchase_products_on_purchase_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.boolean  "paid",            default: false
    t.datetime "paid_at"
    t.integer  "paid_by_id"
    t.integer  "products_amount"
    t.integer  "vendor_id"
    t.integer  "device_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "payment_id"
    t.integer  "tips"
    t.string   "transaction_id"
  end

  add_index "purchases", ["device_id"], name: "index_purchases_on_device_id", using: :btree
  add_index "purchases", ["vendor_id"], name: "index_purchases_on_vendor_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "setting_name"
    t.string   "setting_value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "vendors", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "badge_id"
    t.integer  "updated_by_id"
    t.boolean  "in_app"
    t.boolean  "has_back_issues"
  end

end
