
Manager.create!(name: "マネージャーA",
                email: "managerA@email.com",
                public_uid: "socio",
                password: "password",
                password_confirmation: "password")

puts "CREATE! MANAGER"


Submanager.create!(name: "サブマネA",
                   email: "submanagerA@email.com",
                   password: "password",
                   password_confirmation: "password")

puts "CREATE! SUBMANAGER-A"


Staff.create!(name: "スタッフA",
    email: "staffA@email.com",
    password: "password",
    password_confirmation: "password")

puts "CREATE! STAFF-A"

User.create!(name: "ユーザーA",
            email: "userA@email.com",
            password: "password",
            password_confirmation: "password")

puts "CREATE! USER-A"
