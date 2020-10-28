Admin.create!(name: "管理者",
              login_id: "AD-admin",
              password: "password",
              password_confirmation: "password")

puts "CREATE! ADMIN"

Manager.create!(name: "マネージャーA",
                login_id: "MN-manager-a",
                phone: "08011112222",
                email: "manager-a@email.com",
                password: "password",
                password_confirmation: "password")

Manager.create!(name: "マネージャーB",
                login_id: "MN-manager-b",
                phone: "08011112222",
                email: "manager-b@email.com",
                password: "password",
                password_confirmation: "password")

puts "CREATE! MANAGER"

Staff.create!(name: "スタッフA",
              login_id: "ST-staff-a",
              phone: "08011112222",
              email: "staff-a@email.com",
              password: "password",
              password_confirmation: "password")

Staff.create!(name: "スタッフB",
              login_id: "ST-staff-b",
              phone: "08011662222",
              email: "staff-b@email.com",
              password: "password",
              password_confirmation: "password")

puts "CREATE! STAFF"

Supplier.create!(name: "テスト外注先A",
                 kana: "テストガイチュウサキエー",
                 phone_1: "08054545454",
                 email: "testsupplier-a@email.com",
                 zip_code: "5940088",
                 address: "大阪府テスト市")
          
                 Supplier.create!(name: "テスト外注先B",
                 kana: "テストガイチュウサキビー",
                 phone_1: "08054545774",
                 email: "testsupplier-b@email.com",
                 zip_code: "5940188",
                 address: "大阪府テスト市")

puts "CREATE! Supplier"

ExternalStaff.create!(name: "外部スタッフA",
                      kana: "ガイブスタッフエー",
                      login_id: "SP1-sup-a",
                      phone: "08054545454",
                      email: "testexternal-a@email.com",
                      supplier_id: 1,
                      password: "password",
                      password_confirmation: "password")

ExternalStaff.create!(name: "外部スタッフB",
                      kana: "ガイブスタッフビー",
                      login_id: "SP1-sup-b",
                      phone: "08054545454",
                      email: "testexternal-b@email.com",
                      supplier_id: 1,
                      password: "password",
                      password_confirmation: "password")

puts "CREATE! ExternalStaff"

Industry.create!(name: "塗装関係")
Industry.create!(name: "足場関係")

puts "CREATE! INDUSTRY"

Client.create!(name: "テスト顧客A",
               login_id: "CL-client-a",
               phone_1: "08011112222",
               phone_2: "08011113333",
               email: "testclient-a@email.com",
               zip_code: "5940088",
               address: "大阪府テスト市",
               password: "password",
               password_confirmation: "password")
              
Client.create!(name: "テスト顧客B",
               login_id: "CL-client-b",
               phone_1: "08011112222",
               phone_2: "08011113333",
               email: "testclientr-b@email.com",
               zip_code: "5940088",
               address: "大阪府テスト市",
               password: "password",
               password_confirmation: "password")
               
Client.create!(name: "テスト顧客c",
               login_id: "CL-client-c",
               phone_1: "08011112222",
               phone_2: "08011113333",
               email: "testclientr-c@email.com",
               zip_code: "5940088",
               address: "大阪府テスト市",
               password: "password",
               password_confirmation: "password")

puts "CREATE! CLIENT"

# -----------------------------------------------------
      # MATTER
# ---------------------------------------------

# 1.Matter-----------------

SeedMatter = Matter.create!(title: "案件１",
               status: 0,
               actual_spot: "東京都渋谷区神宮町１−１−１",
               scheduled_started_on:  "2020-07-01",
               scheduled_finished_on: "2020-7-15",
               client_id: '1',
               matter_uid: '1'
               )

puts "CREATE! MATTER1"

SeedMatterB = Matter.create!(title: "案件２",
               status: 1,
               actual_spot: "東京都渋谷区神宮町１−２−１",
               scheduled_started_on: "2020-07-20",
               scheduled_finished_on: "2020-08-30",
               client_id: '2',
               matter_uid: '2'
               )

puts "CREATE! MATTER２"

SeedMatterC = Matter.create!(title: "案件3",
               status: 2,
               actual_spot: "東京都渋谷区神宮町１−２−１",
               scheduled_started_on: "2020-08-20",
               scheduled_finished_on: "2020-09-30",
               client_id: '3',
               matter_uid: '3'
               )

puts "CREATE! MATTER3"


# -----------------------------------------------------
      # TASK
# ---------------------------------------------

Task.create!(title: "TASK1", status: 0, matter_id: '1', default_title: "TASK1")

# TargetManagers = Manager.where(approval: true)
# TargetManagers.each do |manager|
#   Task.all.each do |task|
#     task.manager_tasks.create!(manager_id: manager.id)
#   end
# end
  
puts "CREATE! TASK"