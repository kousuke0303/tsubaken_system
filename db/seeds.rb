
Manager.create!(company: "S0CIO株式会社",
                name: "山本達也",
                email: "test@email.com",
                public_uid: "socio",
                password: "password",
                password_confirmation: "password")

puts "CREATE! MANAGER"

# 3.SUBMANAGER権限------------------

Submanager.create!(name: "サブマネA",
                   email: "submanagerA@email.com",
                   password: "password",
                   password_confirmation: "password")

puts "CREATE! SUBMANAGER-A"

# 4.USER権限------------------------------------

User.create!(name: "ユーザーA",
                   email: "userA@email.com",
                   password: "password",
                   password_confirmation: "password")


puts "CREATE! USER-A"

# 5.STAFF権限----------------------

Staff.create!(name: "スタッフA",
    email: "staffA@email.com",
    password: "password",
    password_confirmation: "password")

puts "CREATE! STAFF-A"

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

Event.create!(title: "打ち合わせ",
    kind: "A",
    holded_on: "2020-07-01",
    note: "仮",
    manager_id: 1,
    matter_id: 1)

puts "CREATE! EVENT-A1"

ManagerEvent.create!(title: "マネージャ独自イベントA",
    kind: "Z",
    holded_on: "2020-07-01",
    note: "",
    manager_id: )

puts "CREATE! MANAGEREVENT-A"

ManagerEventTitle.create!(title: "マネージャ独自イベントA",
    manager_id: ,
    note: "testa")

puts "CREATE! MANAGEREVENTTITLE-A"

Supplier.create!(name: "取引A",
                 address:  "東京都西新宿",
                 address_2: "1-1-1",
                 representative: "山田太郎",
                 phone: "09012341234",
                 fax: "09012351235",
                 email: "companya@email.com",
                 count: 5)

SubmanagerEvent.create!(title: "サブマネージャ独自イベントA",
    kind: "Z",
    holded_on: "2020-07-01",
    note: "",
    submanager_id: 1)

puts "CREATE! SUBMANAGEREVENT-A"

SubmanagerEventTitle.create!(title: "サブマネージャ独自イベントA",
    submanager_id: 1,
    note: "testa")

puts "CREATE! SUBMANAGEREVENTTITLE-A"

StaffEvent.create!(title: "スタッフ独自イベントA",
    kind: "Z",
    holded_on: "2020-07-01",
    note: "",
    staff_id: 1)

puts "CREATE! STAFFEVENT-A"
