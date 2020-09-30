Admin.create!(name: "管理者",
              employee_id: "AD-admin",
              password: "password",
              password_confirmation: "password")

puts "CREATE! ADMIN"

Manager.create!(name: "マネージャーA",
                employee_id: "MN-manager",
                phone: "08011112222"
                email: "managerA@email.com",
                password: "password",
                password_confirmation: "password")

puts "CREATE! MANAGER-A"

Staff.create!(name: "スタッフA",
              employee_id: "ST-staff",
              email: "staffA@email.com",
              password: "password",
              password_confirmation: "password")

puts "CREATE! STAFF-A"
