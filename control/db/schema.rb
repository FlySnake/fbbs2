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

ActiveRecord::Schema.define(version: 20150224154823) do

  create_table "base_versions", force: :cascade do |t|
    t.string   "name",       limit: 128, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "base_versions_enviroments", id: false, force: :cascade do |t|
    t.integer "base_version_id"
    t.integer "enviroment_id"
  end

  add_index "base_versions_enviroments", ["base_version_id"], name: "index_base_versions_enviroments_on_base_version_id"
  add_index "base_versions_enviroments", ["enviroment_id"], name: "index_base_versions_enviroments_on_enviroment_id"

  create_table "branches", force: :cascade do |t|
    t.string   "name",          limit: 512, null: false
    t.integer  "repository_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "branches", ["repository_id"], name: "index_branches_on_repository_id"

  create_table "build_jobs", force: :cascade do |t|
    t.integer  "branch_id",                       null: false
    t.integer  "base_version_id",                 null: false
    t.integer  "enviroment_id",                   null: false
    t.integer  "target_platform_id",              null: false
    t.integer  "notify_user_id",                  null: false
    t.integer  "started_by_user_id",              null: false
    t.string   "comment",            default: "", null: false
    t.integer  "status",                          null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "build_jobs", ["base_version_id"], name: "index_build_jobs_on_base_version_id"
  add_index "build_jobs", ["branch_id"], name: "index_build_jobs_on_branch_id"
  add_index "build_jobs", ["enviroment_id"], name: "index_build_jobs_on_enviroment_id"
  add_index "build_jobs", ["notify_user_id"], name: "index_build_jobs_on_notify_user_id"
  add_index "build_jobs", ["started_by_user_id"], name: "index_build_jobs_on_started_by_user_id"
  add_index "build_jobs", ["target_platform_id"], name: "index_build_jobs_on_target_platform_id"

  create_table "build_numbers", force: :cascade do |t|
    t.string   "branch",        limit: 1024, null: false
    t.string   "commit",        limit: 1024, null: false
    t.integer  "number",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "enviroment_id"
  end

  add_index "build_numbers", ["branch"], name: "index_build_numbers_on_branch"
  add_index "build_numbers", ["enviroment_id"], name: "index_build_numbers_on_enviroment_id"

  create_table "enviroments", force: :cascade do |t|
    t.string   "title",                limit: 1024,              null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "default_build_number",              default: 0,  null: false
    t.integer  "repository_id"
    t.string   "branches_filter",      limit: 2048, default: ""
  end

  add_index "enviroments", ["repository_id"], name: "index_enviroments_on_repository_id"
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
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "target_platforms_workers", id: false, force: :cascade do |t|
    t.integer "target_platform_id"
    t.integer "worker_id"
  end

  add_index "target_platforms_workers", ["target_platform_id"], name: "index_target_platforms_workers_on_target_platform_id"
  add_index "target_platforms_workers", ["worker_id"], name: "index_target_platforms_workers_on_worker_id"

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
