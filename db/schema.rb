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

ActiveRecord::Schema.define(version: 20201103000001) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "auth", default: "admin", null: false
    t.string "name", default: "", null: false
    t.string "email"
    t.string "phone"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_admins_on_login_id", unique: true
  end

  create_table "attendances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "working_minutes"
    t.bigint "manager_id"
    t.bigint "staff_id"
    t.bigint "external_staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_staff_id"], name: "index_attendances_on_external_staff_id"
    t.index ["manager_id"], name: "index_attendances_on_manager_id"
    t.index ["staff_id"], name: "index_attendances_on_staff_id"
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "auth", default: "client", null: false
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
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_clients_on_login_id", unique: true
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "external_staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "auth", default: "external_staff", null: false
    t.string "name", default: "", null: false
    t.string "kana"
    t.string "phone"
    t.string "email"
    t.bigint "supplier_id"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_external_staffs_on_login_id", unique: true
    t.index ["supplier_id"], name: "index_external_staffs_on_supplier_id"
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

  create_table "managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "auth", default: "manager", null: false
    t.string "name", default: "", null: false
    t.string "phone"
    t.string "email"
    t.date "birthed_on"
    t.string "zip_code"
    t.string "address"
    t.date "joined_on"
    t.date "resigned_on"
    t.bigint "department_id"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_managers_on_department_id"
    t.index ["login_id"], name: "index_managers_on_login_id", unique: true
  end

  create_table "matter_managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "matter_id", null: false
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_matter_managers_on_manager_id"
    t.index ["matter_id"], name: "index_matter_managers_on_matter_id"
  end

  create_table "matter_staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "matter_id", null: false
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_staffs_on_matter_id"
    t.index ["staff_id"], name: "index_matter_staffs_on_staff_id"
  end

  create_table "matters", id: :string, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "actual_spot"
    t.string "zip_code"
    t.integer "status"
    t.string "content"
    t.date "scheduled_started_on"
    t.date "started_on"
    t.date "scheduled_finished_on"
    t.date "finished_on"
    t.date "maintenanced_on"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_matters_on_client_id"
  end

  create_table "staff_event_titles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "staff_id"
    t.integer "event_title_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_events", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "staff_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "auth", default: "staff", null: false
    t.string "name", default: "", null: false
    t.string "phone"
    t.string "email"
    t.date "birthed_on"
    t.string "zip_code"
    t.string "address"
    t.date "joined_on"
    t.date "resigned_on"
    t.bigint "department_id"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_staffs_on_department_id"
    t.index ["login_id"], name: "index_staffs_on_login_id", unique: true
  end

  create_table "supplier_matters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "matter_id", null: false
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
    t.integer "status"
    t.integer "before_status"
    t.datetime "moved_on"
    t.integer "sort_order"
    t.string "content"
    t.integer "default_task_id"
    t.boolean "notification", default: false
    t.string "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_tasks_on_matter_id"
  end

  add_foreign_key "attendances", "external_staffs"
  add_foreign_key "attendances", "managers"
  add_foreign_key "attendances", "staffs"
  add_foreign_key "external_staffs", "suppliers"
  add_foreign_key "industry_suppliers", "industries"
  add_foreign_key "industry_suppliers", "suppliers"
  add_foreign_key "managers", "departments"
  add_foreign_key "matter_managers", "managers"
  add_foreign_key "matter_managers", "matters"
  add_foreign_key "matter_staffs", "matters"
  add_foreign_key "matter_staffs", "staffs"
  add_foreign_key "matters", "clients"
  add_foreign_key "staffs", "departments"
  add_foreign_key "supplier_matters", "matters"
  add_foreign_key "supplier_matters", "suppliers"
  add_foreign_key "tasks", "matters"
end
