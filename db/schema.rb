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

ActiveRecord::Schema.define(version: 2019_01_11_084752) do

  create_table "accesses", force: :cascade do |t|
    t.string "name"
    t.string "line"
    t.string "distanceKm"
    t.string "traveltime"
    t.integer "studio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "studio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hash_tag_relationships", force: :cascade do |t|
    t.integer "studio_id"
    t.integer "hash_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hash_tags", force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "review_relationships", force: :cascade do |t|
    t.integer "studio_id"
    t.integer "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "rate"
    t.string "title"
  end

  create_table "studios", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telno"
    t.string "url"
    t.integer "created_user_id"
    t.float "latitude"
    t.float "longitude"
    t.string "image"
    t.string "place_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "image"
    t.integer "review_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
