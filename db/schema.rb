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

ActiveRecord::Schema.define(version: 20200926133207) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.string "employee_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_admins_on_employee_id", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.bigint "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_clients_on_matter_id"
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "kind"
    t.datetime "holded_on"
    t.string "note"
    t.bigint "manager_id"
    t.bigint "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_events_on_manager_id"
    t.index ["matter_id"], name: "index_events_on_matter_id"
  end

  create_table "manager_event_titles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "note"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_event_titles_on_manager_id"
  end

  create_table "manager_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "kind"
    t.datetime "holded_on"
    t.string "note"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_events_on_manager_id"
  end

  create_table "manager_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "manager_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_manager_tasks_on_manager_id"
    t.index ["task_id"], name: "index_manager_tasks_on_task_id"
  end

  create_table "managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.string "phone"
    t.string "email"
    t.date "birthed_on"
    t.string "zip_code"
    t.string "address"
    t.date "joined_on"
    t.date "resigned_on"
    t.string "employee_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_managers_on_employee_id", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "matter_staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "matter_id"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_staffs_on_matter_id"
    t.index ["staff_id"], name: "index_matter_staffs_on_staff_id"
  end

  create_table "matter_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "matter_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_tasks_on_matter_id"
    t.index ["task_id"], name: "index_matter_tasks_on_task_id"
  end

  create_table "matters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "actual_spot_1", comment: "現場住所1"
    t.string "actual_spot_2"
    t.string "zip"
    t.string "status", default: "0", comment: "工事状況"
    t.string "note"
    t.date "scheduled_started_on", comment: "着工予定日"
    t.date "started_on", comment: "着工日"
    t.date "scheduled_finished_on", comment: "完了予定日"
    t.date "finished_on", comment: "完了日"
    t.string "matter_uid", comment: "パラメーター"
    t.string "connected_id", comment: "パラメーター"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_event_titles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "note"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_staff_event_titles_on_staff_id"
  end

  create_table "staff_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "kind"
    t.datetime "holded_on"
    t.string "note"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_staff_events_on_staff_id"
  end

  create_table "staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.string "phone"
    t.string "email"
    t.date "birthed_on"
    t.string "zip_code"
    t.string "address"
    t.date "joined_on"
    t.date "resigned_on"
    t.string "employee_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_staffs_on_employee_id", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
  end

  create_table "suppliers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", comment: "会社名"
    t.string "address_1", comment: "所在地"
    t.string "address_2", comment: "所在地2"
    t.string "zip"
    t.string "representative", comment: "代表者名"
    t.string "phone", comment: "電話番号"
    t.string "fax", comment: "FAX番号"
    t.string "email", comment: "メール"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "status"
    t.string "before_status"
    t.datetime "moved_on"
    t.integer "row_order"
    t.string "note"
    t.string "default_title"
    t.integer "count"
    t.datetime "limited_on"
    t.boolean "notification", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_social_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
  end

  add_foreign_key "clients", "matters"
  add_foreign_key "events", "managers"
  add_foreign_key "events", "matters"
  add_foreign_key "manager_event_titles", "managers"
  add_foreign_key "manager_events", "managers"
  add_foreign_key "manager_tasks", "managers"
  add_foreign_key "manager_tasks", "tasks"
  add_foreign_key "matter_staffs", "matters"
  add_foreign_key "matter_staffs", "staffs"
  add_foreign_key "matter_tasks", "matters"
  add_foreign_key "matter_tasks", "tasks"
  add_foreign_key "staff_event_titles", "staffs"
  add_foreign_key "staff_events", "staffs"
end
