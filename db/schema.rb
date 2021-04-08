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

ActiveRecord::Schema.define(version: 2021_03_29_034919) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "auth", default: "admin", null: false
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_admins_on_login_id", unique: true
  end

  create_table "attendances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "attract_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "band_connections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "estimate_matter_id"
    t.string "matter_id"
    t.string "band_key", null: false
    t.string "band_name", null: false
    t.string "band_icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_band_connections_on_estimate_matter_id"
    t.index ["matter_id"], name: "index_band_connections_on_matter_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position"
    t.integer "classification", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_number"
  end

  create_table "category_materials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "material_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_materials_on_category_id"
    t.index ["material_id"], name: "index_category_materials_on_material_id"
  end

  create_table "certificates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.string "content"
    t.integer "position"
    t.boolean "default", default: false
    t.integer "image_id"
    t.integer "message_id"
    t.string "estimate_matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_certificates_on_estimate_matter_id"
  end

  create_table "clients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "auth", default: "client", null: false
    t.string "name", null: false
    t.boolean "confirmed", default: false, null: false
    t.string "kana"
    t.integer "gender"
    t.string "phone_1"
    t.string "phone_2"
    t.string "fax"
    t.string "email"
    t.date "birthed_on"
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.string "tmp_password"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_clients_on_login_id", unique: true
  end

  create_table "constructions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "default", default: false
    t.string "note"
    t.string "unit"
    t.integer "price"
    t.integer "amount"
    t.string "total"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_constructions_on_category_id"
  end

  create_table "covers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.string "content"
    t.boolean "default", default: false
    t.integer "image_id"
    t.string "estimate_matter_id"
    t.string "publisher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_covers_on_estimate_matter_id"
    t.index ["image_id"], name: "index_covers_on_image_id"
    t.index ["publisher_id"], name: "index_covers_on_publisher_id"
  end

  create_table "departments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estimate_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "estimate_id"
    t.integer "sort_number"
    t.bigint "category_id"
    t.string "category_name"
    t.bigint "material_id"
    t.string "material_name"
    t.bigint "construction_id"
    t.string "construction_name"
    t.string "service_life"
    t.string "note"
    t.string "unit"
    t.integer "price"
    t.integer "amount"
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_estimate_details_on_category_id"
    t.index ["construction_id"], name: "index_estimate_details_on_construction_id"
    t.index ["estimate_id"], name: "index_estimate_details_on_estimate_id"
    t.index ["material_id"], name: "index_estimate_details_on_material_id"
  end

  create_table "estimate_matter_member_codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "estimate_matter_id", null: false
    t.bigint "member_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_estimate_matter_member_codes_on_estimate_matter_id"
    t.index ["member_code_id"], name: "index_estimate_matter_member_codes_on_member_code_id"
  end

  create_table "estimate_matters", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.string "content"
    t.bigint "client_id"
    t.bigint "attract_method_id"
    t.bigint "publisher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attract_method_id"], name: "index_estimate_matters_on_attract_method_id"
    t.index ["client_id"], name: "index_estimate_matters_on_client_id"
    t.index ["publisher_id"], name: "index_estimate_matters_on_publisher_id"
  end

  create_table "estimates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "total_price", default: 0, null: false
    t.integer "discount", default: 0, null: false
    t.string "estimate_matter_id"
    t.integer "position"
    t.bigint "plan_name_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_estimates_on_estimate_matter_id"
    t.index ["plan_name_id"], name: "index_estimates_on_plan_name_id"
  end

  create_table "external_staffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "auth", default: "external_staff", null: false
    t.string "name", null: false
    t.string "kana"
    t.string "phone"
    t.string "email"
    t.date "resigned_on"
    t.boolean "avaliable", default: false, null: false
    t.bigint "supplier_id"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_external_staffs_on_login_id", unique: true
    t.index ["supplier_id"], name: "index_external_staffs_on_supplier_id"
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "content"
    t.string "author"
    t.string "default_file_path"
    t.date "shooted_on"
    t.integer "admin_id"
    t.integer "manager_id"
    t.integer "staff_id"
    t.integer "external_staff_id"
    t.string "estimate_matter_id"
    t.string "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_images_on_estimate_matter_id"
    t.index ["matter_id"], name: "index_images_on_matter_id"
  end

  create_table "industries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_industries_on_name", unique: true
  end

  create_table "industry_suppliers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "industry_id"
    t.bigint "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_industry_suppliers_on_industry_id"
    t.index ["supplier_id"], name: "index_industry_suppliers_on_supplier_id"
  end

  create_table "inquiries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "kind", null: false
    t.string "name"
    t.string "kana"
    t.string "email"
    t.string "phone"
    t.string "reply_email"
    t.datetime "solved_at"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "invoice_id"
    t.integer "sort_number"
    t.bigint "category_id"
    t.string "category_name"
    t.bigint "material_id"
    t.string "material_name"
    t.bigint "construction_id"
    t.string "construction_name"
    t.string "service_life"
    t.string "note"
    t.string "unit"
    t.integer "price"
    t.integer "amount"
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_invoice_details_on_category_id"
    t.index ["construction_id"], name: "index_invoice_details_on_construction_id"
    t.index ["invoice_id"], name: "index_invoice_details_on_invoice_id"
    t.index ["material_id"], name: "index_invoice_details_on_material_id"
  end

  create_table "invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "total_price"
    t.integer "discount", default: 0, null: false
    t.string "matter_id"
    t.date "paid_on"
    t.bigint "plan_name_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_invoices_on_matter_id"
    t.index ["plan_name_id"], name: "index_invoices_on_plan_name_id"
  end

  create_table "label_colors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "color_code", null: false
    t.string "note"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "managers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "auth", default: "manager", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "email"
    t.date "birthed_on"
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.date "joined_on"
    t.date "resigned_on"
    t.boolean "avaliable", default: false, null: false
    t.bigint "department_id"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_managers_on_department_id"
    t.index ["login_id"], name: "index_managers_on_login_id", unique: true
  end

  create_table "materials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "service_life"
    t.string "note"
    t.string "unit"
    t.integer "price"
    t.integer "amount"
    t.string "total"
    t.bigint "plan_name_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_name_id"], name: "index_materials_on_plan_name_id"
  end

  create_table "matter_member_codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "matter_id", null: false
    t.integer "member_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_member_codes_on_matter_id"
    t.index ["member_code_id"], name: "index_matter_member_codes_on_member_code_id"
  end

  create_table "matters", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.string "content"
    t.date "scheduled_started_on"
    t.date "started_on"
    t.date "scheduled_finished_on"
    t.date "finished_on"
    t.integer "status", default: 0, null: false
    t.date "maintenanced_on"
    t.string "estimate_matter_id"
    t.bigint "estimate_id"
    t.bigint "publisher_id"
    t.bigint "client_id"
    t.bigint "attract_method_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attract_method_id"], name: "index_matters_on_attract_method_id"
    t.index ["client_id"], name: "index_matters_on_client_id"
    t.index ["estimate_id"], name: "index_matters_on_estimate_id"
    t.index ["estimate_matter_id"], name: "index_matters_on_estimate_matter_id"
    t.index ["publisher_id"], name: "index_matters_on_publisher_id"
  end

  create_table "member_codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "staff_id"
    t.bigint "manager_id"
    t.bigint "admin_id"
    t.bigint "external_staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_member_codes_on_admin_id"
    t.index ["external_staff_id"], name: "index_member_codes_on_external_staff_id"
    t.index ["manager_id"], name: "index_member_codes_on_manager_id"
    t.index ["staff_id"], name: "index_member_codes_on_staff_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "message"
    t.integer "admin_id"
    t.integer "manager_id"
    t.integer "staff_id"
    t.integer "external_staff_id"
    t.string "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_messages_on_matter_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "category"
    t.integer "action_type"
    t.integer "sender_id"
    t.integer "reciever_id"
    t.string "before_value_1"
    t.string "before_value_2"
    t.string "before_value_3"
    t.string "before_value_4"
    t.text "content"
    t.bigint "schedule_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_notifications_on_schedule_id"
    t.index ["task_id"], name: "index_notifications_on_task_id"
  end

  create_table "plan_names", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position"
    t.bigint "label_color_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_color_id"], name: "index_plan_names_on_label_color_id"
  end

  create_table "publishers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.string "phone"
    t.string "fax"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_covers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.string "matter_id", null: false
    t.string "publisher_id", null: false
    t.integer "img_1_id"
    t.integer "img_2_id"
    t.integer "img_3_id"
    t.integer "img_4_id"
    t.date "created_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_report_covers_on_matter_id"
    t.index ["publisher_id"], name: "index_report_covers_on_publisher_id"
  end

  create_table "reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.integer "position"
    t.boolean "default", default: false
    t.integer "image_id"
    t.integer "message_id"
    t.string "matter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_reports_on_matter_id"
  end

  create_table "sales_status_editors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "member_name"
    t.bigint "sales_status_id"
    t.integer "member_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_code_id"], name: "index_sales_status_editors_on_member_code_id"
    t.index ["sales_status_id"], name: "index_sales_status_editors_on_sales_status_id"
  end

  create_table "sales_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "status", null: false
    t.date "scheduled_date", null: false
    t.string "note"
    t.string "estimate_matter_id"
    t.time "scheduled_start_time"
    t.time "scheduled_end_time"
    t.string "place"
    t.integer "register_for_schedule", default: 0, null: false
    t.integer "member_code_id"
    t.string "member_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_sales_statuses_on_estimate_matter_id"
    t.index ["member_code_id"], name: "index_sales_statuses_on_member_code_id"
  end

  create_table "schedules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "scheduled_date", null: false
    t.time "scheduled_start_time", null: false
    t.time "scheduled_end_time", null: false
    t.string "title", null: false
    t.string "place"
    t.text "note"
    t.text "edit_reason"
    t.boolean "destroy_flag"
    t.string "member_name"
    t.bigint "schedule_id"
    t.bigint "member_code_id"
    t.bigint "staff_id"
    t.bigint "manager_id"
    t.bigint "admin_id"
    t.bigint "external_staff_id"
    t.bigint "sales_status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_schedules_on_admin_id"
    t.index ["external_staff_id"], name: "index_schedules_on_external_staff_id"
    t.index ["manager_id"], name: "index_schedules_on_manager_id"
    t.index ["member_code_id"], name: "index_schedules_on_member_code_id"
    t.index ["sales_status_id"], name: "index_schedules_on_sales_status_id"
    t.index ["schedule_id"], name: "index_schedules_on_schedule_id"
    t.index ["staff_id"], name: "index_schedules_on_staff_id"
  end

  create_table "staff_event_titles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "staff_id"
    t.integer "event_title_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "staff_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "auth", default: "staff", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "email"
    t.date "birthed_on"
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.date "joined_on"
    t.date "resigned_on"
    t.boolean "avaliable", default: false, null: false
    t.bigint "department_id"
    t.bigint "label_color_id"
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_staffs_on_department_id"
    t.index ["label_color_id"], name: "index_staffs_on_label_color_id"
    t.index ["login_id"], name: "index_staffs_on_login_id", unique: true
  end

  create_table "supplier_matters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "matter_id", null: false
    t.bigint "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_supplier_matters_on_matter_id"
    t.index ["supplier_id"], name: "index_supplier_matters_on_supplier_id"
  end

  create_table "suppliers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "kana", null: false
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.string "representative"
    t.string "phone_1"
    t.string "phone_2"
    t.string "fax"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "category"
    t.string "title", default: "", null: false
    t.integer "position"
    t.integer "status"
    t.integer "before_status"
    t.datetime "moved_on"
    t.integer "sort_order"
    t.string "content"
    t.integer "default_task_id"
    t.boolean "alert", default: false
    t.boolean "auto_set", default: false
    t.string "estimate_matter_id"
    t.string "matter_id"
    t.date "deadline"
    t.bigint "member_code_id"
    t.string "member_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_matter_id"], name: "index_tasks_on_estimate_matter_id"
    t.index ["matter_id"], name: "index_tasks_on_matter_id"
    t.index ["member_code_id"], name: "index_tasks_on_member_code_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attendances", "external_staffs"
  add_foreign_key "attendances", "managers"
  add_foreign_key "attendances", "staffs"
  add_foreign_key "category_materials", "categories"
  add_foreign_key "category_materials", "materials"
  add_foreign_key "certificates", "estimate_matters"
  add_foreign_key "constructions", "categories"
  add_foreign_key "estimate_details", "categories"
  add_foreign_key "estimate_details", "constructions"
  add_foreign_key "estimate_details", "estimates"
  add_foreign_key "estimate_details", "materials"
  add_foreign_key "estimate_matter_member_codes", "estimate_matters"
  add_foreign_key "estimate_matters", "attract_methods"
  add_foreign_key "estimate_matters", "clients"
  add_foreign_key "estimate_matters", "publishers"
  add_foreign_key "estimates", "plan_names"
  add_foreign_key "external_staffs", "suppliers"
  add_foreign_key "images", "estimate_matters"
  add_foreign_key "images", "matters"
  add_foreign_key "industry_suppliers", "industries"
  add_foreign_key "industry_suppliers", "suppliers"
  add_foreign_key "invoice_details", "categories"
  add_foreign_key "invoice_details", "constructions"
  add_foreign_key "invoice_details", "invoices"
  add_foreign_key "invoice_details", "materials"
  add_foreign_key "invoices", "plan_names"
  add_foreign_key "managers", "departments"
  add_foreign_key "materials", "plan_names"
  add_foreign_key "matter_member_codes", "matters"
  add_foreign_key "matters", "attract_methods"
  add_foreign_key "matters", "clients"
  add_foreign_key "matters", "estimate_matters"
  add_foreign_key "matters", "estimates"
  add_foreign_key "matters", "publishers"
  add_foreign_key "member_codes", "admins"
  add_foreign_key "member_codes", "external_staffs"
  add_foreign_key "member_codes", "managers"
  add_foreign_key "member_codes", "staffs"
  add_foreign_key "messages", "matters"
  add_foreign_key "notifications", "schedules"
  add_foreign_key "notifications", "tasks"
  add_foreign_key "plan_names", "label_colors"
  add_foreign_key "reports", "matters"
  add_foreign_key "sales_status_editors", "sales_statuses"
  add_foreign_key "staffs", "departments"
  add_foreign_key "staffs", "label_colors"
  add_foreign_key "supplier_matters", "matters"
  add_foreign_key "supplier_matters", "suppliers"
  add_foreign_key "tasks", "estimate_matters"
  add_foreign_key "tasks", "matters"
end
