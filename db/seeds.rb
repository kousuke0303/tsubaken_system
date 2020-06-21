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
                           email: "client@email.com"
                           )
puts "CREATE! MATTER"




