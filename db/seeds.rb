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
               scheduled_start_at: "2020-07-01",
               scheduled_finish_at: "2020-7-30",
               matter_uid: "aa00000001",
               )
SeedMatter.matter_managers.create!(manager_id: 3)
SeedMatter.clients.create!(name: "３匹のこぶた",
                           phone: "09000000000",
                           email: "clientA@email.com"
                           )
SeedMatter.matter_submanagers.create(submanager_id: 1)
SeedMatter.matter_staffs.create(staff_id: 1)

puts "CREATE! MATTER1"

SeedMatterB = Matter.create!(title: "案件２",
               actual_spot: "東京都渋谷区神宮町１−２−１",
               scheduled_start_at: "2020-07-01",
               scheduled_finish_at: "2020-7-30",
               matter_uid: "aa00000002",
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

SeedTask = Task.create!(title: "TASK1", default_title: "TASK1")
SeedTask.manager_tasks.create!(manager_id: 3)

puts "CREATE! TASK1"

SeedTaskB = Task.create!(title: "TASK2", default_title: "TASK2")
SeedTaskB.manager_tasks.create!(manager_id: 3)

puts "CREATE! TASK2"

SeedTaskC = Task.create!(title: "TASK3", default_title: "TASK3")
SeedTaskC.manager_tasks.create!(manager_id: 3)

puts "CREATE! TASK3"



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

Event.create!(event_name: "確定した工事着手日",
    event_type: "C",
    date: "2020-07-03",
    note: "仮",
    manager_id: 3,
    matter_id: 1)

puts "CREATE! EVENT-C"

Event.create!(event_name: "予定された工事着手日",
    event_type: "D",
    date: "2020-07-03",
    note: "仮",
    manager_id: 3,
    matter_id: 1)

puts "CREATE! EVENT-D1"

Event.create!(event_name: "予定された工事着手日",
    event_type: "D",
    date: "2020-07-01",
    note: "仮",
    manager_id: 2,
    matter_id: 1)

puts "CREATE! EVENT-D2"
