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

ActiveRecord::Schema.define(version: 20201010002755) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_admins_on_login_id", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.string "kana"
    t.integer "gender"
    t.string "phone_1"
    t.string "phone_2"
    t.string "fax"
    t.string "email"
    t.date "birthed_on"
    t.string "zip_code"
    t.string "address"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "無所属", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "industries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_industries_on_name", unique: true
  end

  create_table "industry_suppliers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "industry_id"
    t.bigint "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_industry_suppliers_on_industry_id"
    t.index ["supplier_id"], name: "index_industry_suppliers_on_supplier_id"
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
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_managers_on_login_id", unique: true
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
    t.string "actual_spot"
    t.string "zip_code"
    t.string "status"
    t.string "content"
    t.date "scheduled_started_on"
    t.date "started_on"
    t.date "scheduled_finished_on"
    t.date "finished_on"
    t.date "maintenanced_on"
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
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_staffs_on_login_id", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
  end

  create_table "supplier_matters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "matter_id"
    t.bigint "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_supplier_matters_on_matter_id"
    t.index ["supplier_id"], name: "index_supplier_matters_on_supplier_id"
  end

  create_table "suppliers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "kana"
    t.string "address"
    t.string "zip_code"
    t.string "representative"
    t.string "phone_1"
    t.string "phone_2"
    t.string "fax"
    t.string "email"
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

  add_foreign_key "events", "managers"
  add_foreign_key "events", "matters"
  add_foreign_key "industry_suppliers", "industries"
  add_foreign_key "industry_suppliers", "suppliers"
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
  add_foreign_key "supplier_matters", "matters"
  add_foreign_key "supplier_matters", "suppliers"
end
