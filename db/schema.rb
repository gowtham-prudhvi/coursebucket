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

ActiveRecord::Schema.define(version: 20161108124927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ads", force: :cascade do |t|
    t.string   "name"
    t.string   "taste"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalog", force: :cascade do |t|
    t.string "course_id",   limit: 255,    null: false
    t.string "name",        limit: 255
    t.string "slug",        limit: 255
    t.string "course_site", limit: 255
    t.string "instructors", limit: 255000
    t.string "partners",    limit: 255000
    t.string "homepage",    limit: 255000
  end

  create_table "catalogs", id: :string, limit: 255, force: :cascade do |t|
    t.string "name",        limit: 255
    t.string "slug",        limit: 255
    t.string "course_site", limit: 255
  end

  create_table "deviseusers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
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
    t.index ["email"], name: "index_deviseusers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_deviseusers_on_reset_password_token", unique: true, using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_recent_search", force: :cascade do |t|
    t.integer "user_id",      null: false
    t.string  "search_field", null: false
  end

  create_table "usermails", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string  "email",      limit: 50,             null: false
    t.string  "password",                          null: false
    t.string  "first_name", limit: 30,             null: false
    t.string  "last_name",  limit: 30,             null: false
    t.integer "active",                default: 1, null: false
  end

end
