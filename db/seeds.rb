Admin.create!(name: "管理者",
              login_id: "AD-admin",
              password: "password",
              password_confirmation: "password")

puts "CREATE! ADMIN"

Manager.create!(name: "マネージャーA",
                login_id: "MN-manager",
                phone: "08011112222",
                email: "manager-a@email.com",
                password: "password",
                password_confirmation: "password")

puts "CREATE! MANAGER-A"

Staff.create!(name: "スタッフA",
              login_id: "ST-staff",
              phone: "08011112222",
              email: "staff-a@email.com",
              password: "password",
              password_confirmation: "password")

puts "CREATE! STAFF-A"
