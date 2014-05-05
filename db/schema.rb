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

ActiveRecord::Schema.define(version: 20140505112807) do

  create_table "products", force: true do |t|
    t.string   "name"
    t.float    "amount"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "products", ["seller_id"], name: "index_products_on_seller_id"

  create_table "sales", force: true do |t|
    t.integer  "buyer_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales", ["buyer_id"], name: "index_sales_on_buyer_id"
  add_index "sales", ["product_id"], name: "index_sales_on_product_id"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
