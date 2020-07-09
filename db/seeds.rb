#------------------------------------------------------
    # 権限
# ----------------------------------------------------

# 1.管理者権限---------------

Admin.create!(email: "test12345@email.com",
              password: "password12345",
              password_confirmation: "password12345")
puts "CREATE! ADMIN"

# -------------------------------------------------


# 2.MANAGER権限--------------

# 未承認------------------
Manager.create!(company: "株式会社Tokkun",
                name: "Modalist徳永",
                email: "toku@email.com",
                password: "password",
                password_confirmation: "password",
                approval: false)

puts "CREATE! NON_APPROVAL_MANAGER"

# 承認--------------------
Manager.create!(company: "S0CIO株式会社",
                name: "山本達也",
                email: "test@email.com",
                public_uid: "socio",
                password: "password",
                password_confirmation: "password",
                approval: true)

puts "CREATE! APPROVAL_MANAGER1"

Manager.create!(company: "KIDA株式会社",
                name: "貴田",
                email: "kida@email.com",
                public_uid: "kida",
                password: "password",
                password_confirmation: "password",
                approval: true)

puts "CREATE! APPROVAL_MANAGER2"

Manager.create!(company: "MARU株式会社",
                name: "MARU",
                email: "maru@email.com",
                public_uid: "MARU",
                password: "password",
                password_confirmation: "password",
                approval: true)

puts "CREATE! APPROVAL_MANAGER3"

# ------------------------------------------------------

# 3.SUBMANAGER権限------------------

Submanager.create!(name: "サブマネA",
                   email: "submanagerA@email.com",
                   password: "password",
                   password_confirmation: "password",
                   manager_id: 3)

puts "CREATE! SUBMANAGER-A"

Submanager.create!(name: "サブマネB",
                   email: "submanagerb@email.com",
                   password: "password",
                   password_confirmation: "password",
                   manager_id: 3)

puts "CREATE! SUBMANAGER-B"

# ------------------------------------------------------

# 4.USER権限------------------------------------

User.create!(name: "ユーザーA",
                   email: "userA@email.com",
                   password: "password",
                   password_confirmation: "password")

ManagerUser.create!(manager_id: 3, user_id: 1)

puts "CREATE! USER-A"

User.create!(name: "ユーザーB",
                   email: "userB@email.com",
                   password: "password",
                   password_confirmation: "password")

ManagerUser.create!(manager_id: 3, user_id: 2)

puts "CREATE! USER-B"

# ------------------------------------------------------

# 5.STAFF権限----------------------

Staff.create!(name: "スタッフA",
    email: "staffA@email.com",
    password: "password",
    password_confirmation: "password")

ManagerStaff.create!(manager_id: 3, staff_id: 1)

puts "CREATE! STAFF-A"

Staff.create!(name: "スタッフB",
    email: "staffB@email.com",
    password: "password",
    password_confirmation: "password")

ManagerStaff.create!(manager_id: 3, staff_id: 2)

puts "CREATE! STAFF-B"

# ----------------
    # 権限END
# ------------------------------------------------------

# -----------------------------------------------------
      # MATTER
# ---------------------------------------------

# 1.Matter-----------------

SeedMatter = Matter.create!(title: "案件１",
               actual_spot: "東京都渋谷区神宮町１−１−１",
               started_at: "2020-07-01",
               scheduled_finish_at: "2020-7-15",
               matter_uid: "aa00000001",
               connected_id: "testtest01"
               )
SeedMatter.matter_managers.create!(manager_id: 3)
SeedMatter.clients.create!(name: "３匹のこぶた",
                           phone: "09000000000",
                           email: "clientA@email.com"
                           )
puts "CREATE! MATTER1"

SeedMatterB = Matter.create!(title: "案件２",
               actual_spot: "東京都渋谷区神宮町１−２−１",
               scheduled_start_at: "2020-07-20",
               scheduled_finish_at: "2020-08-30",
               matter_uid: "aa00000002",
               connected_id: "testtest02"
               )
SeedMatterB.matter_managers.create!(manager_id: 3)
SeedMatterB.clients.create!(name: "鬼ちゃん",
                           phone: "09000000000",
                           email: "clientB@email.com"
                           )
puts "CREATE! MATTER２"

# -----------------------------------------------------
      # TASK
# ---------------------------------------------

# 1.Manager_task-----------------

1.upto(9) do |i|
  Task.create!(title: "TASK#{i}", default_title: "TASK#{i}")
end

TargetManagers = Manager.where(approval: true)
TargetManagers.each do |manager|
  Task.all.each do |task|
    task.manager_tasks.create!(manager_id: manager.id)
  end
end
  
puts "CREATE! MANAGERTASK"



# -----------------------------------------------------
      # EVENT
# ---------------------------------------------

Event.create!(event_name: "打ち合わせ",
    event_type: "A",
    date: "2020-07-01",
    note: "仮",
    manager_id: 2,
    matter_id: 1)

puts "CREATE! EVENT-A1"

Event.create!(event_name: "打ち合わせ",
    event_type: "A",
    date: "2020-06-30",
    note: "仮",
    manager_id: 2,
    matter_id: 1)

puts "CREATE! EVENT-A2"

Event.create!(event_name: "打ち合わせ",
    event_type: "A",
    date: "2020-07-02",
    note: "仮",
    manager_id: 3,
    matter_id: 1)

puts "CREATE! EVENT-A3"

Event.create!(event_name: "入金予定",
    event_type: "B",
    date: "2020-07-03",
    note: "仮入金",
    manager_id: 3,
    matter_id: 1)

puts "CREATE! EVENT-B"

Event.create!(event_name: "工事着工日",
    event_type: "C",
    date: "2020-07-03",
    note: "仮",
    manager_id: 3,
    matter_id: 1)

puts "CREATE! EVENT-C"

Event.create!(event_name: "工事着工予定",
    event_type: "D",
    date: "2020-07-03",
    note: "仮",
    manager_id: 3,
    matter_id: 1)

puts "CREATE! EVENT-D1"

Event.create!(event_name: "工事着工予定",
    event_type: "D",
    date: "2020-07-01",
    note: "仮",
    manager_id: 2,
    matter_id: 1)

puts "CREATE! EVENT-D2"

ManagerEvent.create!(event_name: "マネージャ独自イベントA",
    event_type: "Z",
    date: "2020-07-01",
    note: "",
    manager_id: 3,)

puts "CREATE! MANAGEREVENT-A"

ManagerEvent.create!(event_name: "マネージャ独自イベントB",
    event_type: "Z",
    date: "2020-07-01",
    note: "",
    manager_id: 2,)

puts "CREATE! MANAGEREVENT-B"

ManagerEventTitle.create!(event_name: "マネージャ独自イベントA",
    manager_id: 3,
    note: "testa")

puts "CREATE! MANAGEREVENTTITLE-A"

ManagerEventTitle.create!(event_name: "マネージャ独自イベントB",
    manager_id: 2,
    note: "testb")

puts "CREATE! MANAGEREVENTTITLE-B"

# -----------------------------------------------------
      # SUPPLIER
# ---------------------------------------------

Supplier.create!(company: "取引A",
                 location:  "東京都西新宿１−３−２",
                 representative_name: "山田太郎",
                 phone: "09012341234",
                 fax: "09012351235",
                 mail: "companya@email.com",
                 count: 5,
                 manager_id: 3)

Supplier.create!(company: "取引B",
                 location:  "東京都西新宿１−９−２",
                 representative_name: "山田太郎",
                 phone: "09012361236",
                 fax: "09012381238",
                 mail: "companyb@email.com",
                 count: 3,
                 manager_id: 3)

puts "CREATE!SUPPLIER"


SubmanagerEvent.create!(event_name: "サブマネージャ独自イベントA",
    event_type: "Z",
    date: "2020-07-01",
    note: "",
    submanager_id: 1,)

puts "CREATE! SUBMANAGEREVENT-A"

SubmanagerEvent.create!(event_name: "サブマネージャ独自イベントB",
    event_type: "Z",
    date: "2020-07-01",
    note: "",
    submanager_id: 2,)

puts "CREATE! SUBMANAGEREVENT-B"

SubmanagerEventTitle.create!(event_name: "サブマネージャ独自イベントA",
    submanager_id: 1,
    note: "testa")

puts "CREATE! SUBMANAGEREVENTTITLE-A"

SubmanagerEventTitle.create!(event_name: "サブマネージャ独自イベントB",
    submanager_id: 2,
    note: "testb")

puts "CREATE! SUBMANAGEREVENTTITLE-B"
