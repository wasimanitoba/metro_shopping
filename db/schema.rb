# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_03_132750) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.string "category"
    t.string "brand"
    t.string "filterable_attributes"
    t.string "picture"
  end

  create_table "packages", force: :cascade do |t|
    t.integer "measurement_units"
    t.decimal "measurement"
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_packages_on_item_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.decimal "cost", null: false
    t.decimal "discount", default: "0.0"
    t.decimal "price", null: false
    t.integer "quantity", default: 1, null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id", null: false
    t.decimal "price_per_unit"
    t.bigint "package_id", null: false
    t.index ["package_id"], name: "index_purchases_on_package_id"
    t.index ["store_id"], name: "index_purchase_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.point "location"
    t.boolean "deleted", default: false
    t.string "owner"
    t.datetime "created_at", null: false
    t.string "place"
  end

  add_foreign_key "packages", "items"
  add_foreign_key "purchases", "packages"
  add_foreign_key "purchases", "stores"
end
