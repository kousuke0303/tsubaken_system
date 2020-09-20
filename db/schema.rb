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

ActiveRecord::Schema.define(version: 20200712132740) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", comment: "名前"
    t.string "phone", comment: "連絡先"
    t.string "fax", comment: "FAX"
    t.string "email", comment: "email"
    t.bigint "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_clients_on_matter_id"
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name"
    t.string "event_type"
    t.datetime "date"
    t.string "note"
    t.bigint "manager_id"
    t.bigint "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_events_on_manager_id"
    t.index ["matter_id"], name: "index_events_on_matter_id"
  end

  create_table "manager_event_titles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.index ["manager_id"], name: "index_manager_event_titles_on_manager_id"
  end

  create_table "manager_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name"
    t.string "event_type"
    t.datetime "date"
    t.string "note"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_events_on_manager_id"
  end

  create_table "manager_staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee", default: 0
    t.bigint "manager_id"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_staffs_on_manager_id"
    t.index ["staff_id"], name: "index_manager_staffs_on_staff_id"
  end

  create_table "manager_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "manager_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_tasks_on_manager_id"
    t.index ["task_id"], name: "index_manager_tasks_on_task_id"
  end

  create_table "manager_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_users_on_manager_id"
    t.index ["user_id"], name: "index_manager_users_on_user_id"
  end

  create_table "managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "phone"
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

  create_table "matter_managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "matter_id"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_matter_managers_on_manager_id"
    t.index ["matter_id"], name: "index_matter_managers_on_matter_id"
  end

  create_table "matter_staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "matter_id"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_staffs_on_matter_id"
    t.index ["staff_id"], name: "index_matter_staffs_on_staff_id"
  end

  create_table "matter_submanagers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean "manage_authority", default: false
    t.bigint "matter_id"
    t.bigint "submanager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_submanagers_on_matter_id"
    t.index ["submanager_id"], name: "index_matter_submanagers_on_submanager_id"
  end

  create_table "matter_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "matter_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_tasks_on_matter_id"
    t.index ["task_id"], name: "index_matter_tasks_on_task_id"
  end

  create_table "matter_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "matter_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_users_on_matter_id"
    t.index ["user_id"], name: "index_matter_users_on_user_id"
  end

  create_table "matters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title", comment: "事件名"
    t.string "actual_spot", comment: "現場"
    t.string "actual_spot_2"
    t.string "zip"
    t.string "status", default: "0", comment: "工事状況"
    t.string "note", comment: "備考"
    t.date "scheduled_start_at", comment: "着工予定日"
    t.date "started_at", comment: "着工日"
    t.date "scheduled_finish_at", comment: "完了予定日"
    t.date "finished_at", comment: "完了日"
    t.string "matter_uid", comment: "パラメーター"
    t.string "connected_id", comment: "パラメーター"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_event_titles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name"
    t.string "note"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_staff_event_titles_on_staff_id"
  end

  create_table "staff_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name"
    t.string "event_type"
    t.datetime "date"
    t.string "note"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_staff_events_on_staff_id"
  end

  create_table "staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "staffs_attendances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.bigint "staff_id"
    t.bigint "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_staffs_attendances_on_matter_id"
    t.index ["staff_id"], name: "index_staffs_attendances_on_staff_id"
  end

  create_table "submanager_event_titles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name"
    t.string "note"
    t.bigint "submanager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submanager_id"], name: "index_submanager_event_titles_on_submanager_id"
  end

  create_table "submanager_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name"
    t.string "event_type"
    t.datetime "date"
    t.string "note"
    t.bigint "submanager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submanager_id"], name: "index_submanager_events_on_submanager_id"
  end

  create_table "submanagers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_submanagers_on_email", unique: true
    t.index ["manager_id"], name: "index_submanagers_on_manager_id"
    t.index ["reset_password_token"], name: "index_submanagers_on_reset_password_token", unique: true
  end

  create_table "submanagers_attendances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "submanager_id"
    t.bigint "matter_id"
    t.index ["matter_id"], name: "index_submanagers_attendances_on_matter_id"
    t.index ["submanager_id"], name: "index_submanagers_attendances_on_submanager_id"
  end

  create_table "suppliers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "company", comment: "会社名"
    t.string "actual_spot", comment: "所在地"
    t.string "actual_spot_2", comment: "所在地2"
    t.string "zip"
    t.string "representative_name", comment: "代表者名"
    t.string "phone", comment: "電話番号"
    t.string "fax", comment: "FAX番号"
    t.string "mail", comment: "メール"
    t.integer "count", comment: "関連事件数"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_suppliers_on_manager_id"
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "status"
    t.string "before_status"
    t.datetime "move_date"
    t.integer "row_order"
    t.text "memo"
    t.string "default_title"
    t.integer "count"
    t.datetime "deadline"
    t.boolean "notification", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_social_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
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

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  add_foreign_key "clients", "matters"
  add_foreign_key "events", "managers"
  add_foreign_key "events", "matters"
  add_foreign_key "manager_event_titles", "managers"
  add_foreign_key "manager_events", "managers"
  add_foreign_key "manager_staffs", "managers"
  add_foreign_key "manager_staffs", "staffs"
  add_foreign_key "manager_tasks", "managers"
  add_foreign_key "manager_tasks", "tasks"
  add_foreign_key "manager_users", "managers"
  add_foreign_key "manager_users", "users"
  add_foreign_key "matter_managers", "managers"
  add_foreign_key "matter_managers", "matters"
  add_foreign_key "matter_staffs", "matters"
  add_foreign_key "matter_staffs", "staffs"
  add_foreign_key "matter_submanagers", "matters"
  add_foreign_key "matter_submanagers", "submanagers"
  add_foreign_key "matter_tasks", "matters"
  add_foreign_key "matter_tasks", "tasks"
  add_foreign_key "matter_users", "matters"
  add_foreign_key "matter_users", "users"
  add_foreign_key "staff_event_titles", "staffs"
  add_foreign_key "staff_events", "staffs"
  add_foreign_key "staffs_attendances", "matters"
  add_foreign_key "staffs_attendances", "staffs"
  add_foreign_key "submanager_event_titles", "submanagers"
  add_foreign_key "submanager_events", "submanagers"
  add_foreign_key "submanagers", "managers"
  add_foreign_key "submanagers_attendances", "matters"
  add_foreign_key "submanagers_attendances", "submanagers"
  add_foreign_key "suppliers", "managers"
  add_foreign_key "user_social_profiles", "users"
end
