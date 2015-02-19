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

ActiveRecord::Schema.define(version: 20150219152234) do

  create_table "branches", force: :cascade do |t|
    t.string   "name",          limit: 512, null: false
    t.integer  "repository_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "branches", ["repository_id"], name: "index_branches_on_repository_id"

  create_table "build_numbers", force: :cascade do |t|
    t.string   "branch",        limit: 1024, null: false
    t.string   "commit",        limit: 1024, null: false
    t.string   "number",        limit: 1024, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "enviroment_id"
  end

  add_index "build_numbers", ["branch"], name: "index_build_numbers_on_branch"
  add_index "build_numbers", ["enviroment_id"], name: "index_build_numbers_on_enviroment_id"

  create_table "enviroments", force: :cascade do |t|
    t.string   "title",      limit: 1024, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "enviroments", ["title"], name: "index_enviroments_on_title"

  create_table "repositories", force: :cascade do |t|
    t.string   "title",      limit: 512,  default: "", null: false
    t.string   "path",       limit: 4096,              null: false
    t.integer  "vcs_type",                             null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "target_platforms", force: :cascade do |t|
    t.string   "title",      limit: 512, null: false
    t.integer  "worker_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "target_platforms", ["worker_id"], name: "index_target_platforms_on_worker_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "workers", force: :cascade do |t|
    t.string   "title",      null: false
    t.string   "address",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
