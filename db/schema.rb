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

ActiveRecord::Schema.define(version: 20200704190138) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.integer "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_clients_on_matter_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_name"
    t.string "event_type"
    t.datetime "date"
    t.string "note"
    t.integer "manager_id"
    t.integer "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_events_on_manager_id"
    t.index ["matter_id"], name: "index_events_on_matter_id"
  end

  create_table "manager_event_titles", force: :cascade do |t|
    t.string "event_name"
    t.integer "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.index ["manager_id"], name: "index_manager_event_titles_on_manager_id"
  end

  create_table "manager_events", force: :cascade do |t|
    t.string "event_name"
    t.string "event_type"
    t.datetime "date"
    t.string "note"
    t.integer "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_events_on_manager_id"
  end

  create_table "manager_staffs", force: :cascade do |t|
    t.integer "manager_id"
    t.integer "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_staffs_on_manager_id"
    t.index ["staff_id"], name: "index_manager_staffs_on_staff_id"
  end

  create_table "manager_tasks", force: :cascade do |t|
    t.integer "manager_id"
    t.integer "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_tasks_on_manager_id"
    t.index ["task_id"], name: "index_manager_tasks_on_task_id"
  end

  create_table "manager_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_users_on_manager_id"
    t.index ["user_id"], name: "index_manager_users_on_user_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "name", null: false
    t.string "mobile_phone"
    t.string "company"
    t.string "public_uid"
    t.boolean "approval", default: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_managers_on_email", unique: true
    t.index ["public_uid"], name: "index_managers_on_public_uid", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "matter_managers", force: :cascade do |t|
    t.integer "matter_id"
    t.integer "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_matter_managers_on_manager_id"
    t.index ["matter_id"], name: "index_matter_managers_on_matter_id"
  end

  create_table "matter_staffs", force: :cascade do |t|
    t.integer "matter_id"
    t.integer "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_staffs_on_matter_id"
    t.index ["staff_id"], name: "index_matter_staffs_on_staff_id"
  end

  create_table "matter_submanagers", force: :cascade do |t|
    t.boolean "manage_authority", default: false
    t.integer "matter_id"
    t.integer "submanager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_submanagers_on_matter_id"
    t.index ["submanager_id"], name: "index_matter_submanagers_on_submanager_id"
  end

  create_table "matter_tasks", force: :cascade do |t|
    t.integer "matter_id"
    t.integer "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_tasks_on_matter_id"
    t.index ["task_id"], name: "index_matter_tasks_on_task_id"
  end

  create_table "matter_users", force: :cascade do |t|
    t.integer "matter_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_users_on_matter_id"
    t.index ["user_id"], name: "index_matter_users_on_user_id"
  end

  create_table "matters", force: :cascade do |t|
    t.string "title"
    t.string "actual_spot"
    t.string "status", default: "f"
    t.string "note"
    t.date "scheduled_start_at"
    t.date "started_at"
    t.date "scheduled_finish_at"
    t.date "finished_at"
    t.string "matter_uid"
    t.string "connected_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staffs", force: :cascade do |t|
    t.string "name"
    t.string "phone"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
  end

  create_table "submanagers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
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
    t.integer "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_submanagers_on_email", unique: true
    t.index ["manager_id"], name: "index_submanagers_on_manager_id"
    t.index ["reset_password_token"], name: "index_submanagers_on_reset_password_token", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.integer "row_order"
    t.text "memo"
    t.string "default_title"
    t.integer "count"
    t.datetime "deadline"
    t.boolean "notification", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_social_profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.string "url"
    t.string "image_url"
    t.string "description"
    t.text "other"
    t.text "credentials"
    t.text "raw_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_user_social_profiles_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_user_social_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "fax"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
