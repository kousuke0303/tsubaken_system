
Manager.create!(name: "マネージャーA",
                email: "managerA@email.com",
                password: "password",
                password_confirmation: "password")

puts "CREATE! MANAGER"

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
