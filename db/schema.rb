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

ActiveRecord::Schema.define(version: 20150702060608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blogs", ["slug"], name: "index_blogs_on_slug", using: :btree

  create_table "entries", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.date     "title_date"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "entry_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.date     "attachment_updated_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "resources", ["attachment_content_type"], name: "index_resources_on_attachment_content_type", using: :btree
  add_index "resources", ["entry_id"], name: "index_resources_on_entry_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "taggings", ["entry_id"], name: "index_taggings_on_entry_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["ancestry"], name: "index_tags_on_ancestry", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

  add_foreign_key "entries", "users"
  add_foreign_key "resources", "entries"
  add_foreign_key "taggings", "entries"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "users"
end
