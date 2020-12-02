Department.create!(name: "無所属")
Department.create!(name: "営業")

puts "CREATE! DEPARTMENT"

Admin.create!(name: "管理者",
              login_id: "AD-admin",
              password: "password",
              password_confirmation: "password")

puts "CREATE! ADMIN"

puts "CREATE! Department"

3.times do |n|
  Manager.create!(name: "マネージャー#{ n + 1 }",
                  login_id: "MN-manager-#{ n + 1 }",
                  phone: "08011112222",
                  email: "manager-#{ n + 1 }@email.com",
                  department_id: 2,
                  password: "password",
                  password_confirmation: "password")
end

puts "CREATE! MANAGER"

3.times do |n|
  Staff.create!(name: "スタッフ#{ n + 1 }",
                login_id: "ST-staff-#{ n + 1 }",
                phone: "08011112222",
                email: "staff-#{ n + 1 }@email.com",
                department_id: 2,
                password: "password",
                password_confirmation: "password")
end

puts "CREATE! STAFF"

3.times do |n|
  Supplier.create!(name: "テスト外注先#{ n + 1 }",
                  kana: "テストガイチュウサキ",
                  phone_1: "08054545454",
                  email: "testsupplier-#{ n + 1 }@email.com",
                  zip_code: "5940088",
                  address: "大阪府テスト市")
end

puts "CREATE! Supplier"

3.times do |n|
ExternalStaff.create!(name: "外部スタッフ#{ n + 1 }",
                      kana: "ガイブスタッフ",
                      login_id: "SP1-sup-#{ n + 1 }",
                      phone: "08054545454",
                      email: "testexternal-a@email.com",
                      supplier_id: 1,
                      password: "password",
                      password_confirmation: "password")
end

puts "CREATE! ExternalStaff"

Industry.create!(name: "塗装関係")
Industry.create!(name: "足場関係")

puts "CREATE! INDUSTRY"

3.times do |n|
  Client.create!(name: "テスト顧客#{ n + 1 }",
                login_id: "CL-client-#{ n + 1 }",
                phone_1: "08011112222",
                phone_2: "08011113333",
                email: "client-#{ n + 1 }@email.com",
                zip_code: "5940088",
                address: "大阪府テスト市",
                password: "password",
                password_confirmation: "password")
end

puts "CREATE! CLIENT"

# -----------------------------------------------------
      # MATTER
# -----------------------------------------------------

SeedEstimateMatter1 = EstimateMatter.create!(title: "見積案件１",
                                             status: 0,
                                             actual_spot: "東京都渋谷区神宮町１−１−１",
                                             client_id: 1,
                                             )

SeedEstimateMatter2 = EstimateMatter.create!(title: "見積案件２",
                                             status: 0,
                                             actual_spot: "東京都渋谷区神宮町１−２−１",
                                             client_id: 2,
                                             )                                          

puts "CREATE! ESTIMATE_MATTER"

SeedMatter1 = Matter.create!(title: "案件１",
                             status: 0,
                             actual_spot: "東京都渋谷区神宮町１−１−１",
                             estimate_matter_id: SeedEstimateMatter1.id
                             )

SeedMatter2 = Matter.create!(title: "案件2",
                             status: 0,
                             actual_spot: "東京都渋谷区神宮町１−１−１",
                             estimate_matter_id: SeedEstimateMatter2.id
                             )
puts "CREATE! MATTER"

# -----------------------------------------------------
      # TASK
# -----------------------------------------------------

3.times do |n|
  Task.create!(title: "TASK#{ n + 1 }", status: 0, title: "DEFALTE_TASK_#{ n + 1 }",  content: "テスト内容", sort_order: n, default_task_id: "#{ n + 1 }")
end

puts "CREATE! DEFALTE_TASK"

3.times do |n|
  Task.create!(title: "TASK#{ n + 1 }", status: 1, title: "当該タスク#{ n + 1 }", content: "テスト内容", sort_order: n, matter_id: SeedMatter1.id)
  Task.create!(title: "TASK#{ n + 1 }", status: 2, title: "進行中タスク#{ n + 1 }", content: "テスト内容", sort_order: n, matter_id: SeedMatter1.id)
end

3.times do |n|
  Task.create!(title: "TASK#{ n + 1 }", status: 1, title: "当該タスク#{ n + 1 }", content: "テスト内容", sort_order: n, matter_id: SeedMatter2.id)
  Task.create!(title: "TASK#{ n + 1 }", status: 2, title: "進行中タスク#{ n + 1 }", content: "テスト内容", sort_order: n, matter_id: SeedMatter2.id)
end

puts "CREATE! TASK"

first_day = Date.current.beginning_of_month
last_day = first_day.end_of_month
one_month = [*first_day..last_day]
today = Date.current
year = today.year
month = today.month
day = today.day
Manager.all.each do |manager|
  one_month.each { |day| manager.attendances.create!(worked_on: day) }
  manager.attendances.find_by(worked_on: Date.current).update(started_at: "#{year}-#{month}-#{day} 09:00:00",
                                                                          finished_at: "#{year}-#{month}-#{day} 17:00:00")
end

Staff.all.each do |staff|
  one_month.each { |day| staff.attendances.create!(worked_on: day) }
  staff.attendances.find_by(worked_on: Date.current).update(started_at: "#{year}-#{month}-#{day} 09:00:00",
                                                                        finished_at: "#{year}-#{month}-#{day} 17:00:00")
end

ExternalStaff.all.each do |external_staff|
  one_month.each { |day| external_staff.attendances.create!(worked_on: day) }
  external_staff.attendances.find_by(worked_on: Date.current).update(started_at: "#{year}-#{month}-#{day} 09:00:00",
                                                                                 finished_at: "#{year}-#{month}-#{day} 17:00:00")
end

puts "CREATE! ATTENDANCES"

3.times do |n|
  Category.create(title: "テストカテゴリ#{ n + 1 }")
end

puts "CREATE! CATEGORIES"

3.times do |n|
  Kind.create(title: "テストタイプ#{ n + 1 }", category_id: 1, amount: "10000")
end

puts "CREATE! KINDS"
