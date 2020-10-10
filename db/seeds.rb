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

Supplier.create!(name: "テスト外注先AA",
                 kana: "テストガイチュウサキ",
                 phone_1: "08054545454",
                 email: "testsupplierA@email.com",
                 zip_code: "5940088",
                 address: "大阪府テスト市")

puts "CREATE! SupplierA"

Industry.create!(name: "塗装関係")

puts "CREATE! INDUSTRY"
