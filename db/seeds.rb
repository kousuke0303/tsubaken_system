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
                  postal_code: "5940088",
                  prefecture_code: "神奈川県",
                  address_city: "テスト市テスト町",
                  address_street: "1-1-1")
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
                 kana: "テストコキャク",
                 login_id: "CL-client-#{ n + 1 }",
                 phone_1: "08011112222",
                 phone_2: "08011113333",
                 email: "client-#{ n + 1 }@email.com",
                 postal_code: "5940088",
                 prefecture_code: "神奈川県",
                 address_city: "テスト市テスト町",
                 address_street: "1-1-1",
                 password: "password",
                 password_confirmation: "password")
end

puts "CREATE! CLIENT"

# -----------------------------------------------------
      # 案件関連
# -----------------------------------------------------

SeedEstimateMatter1 = EstimateMatter.create!(title: "見積案件1",
                                             content: "見積案件1の内容",
                                             postal_code: "5940088",
                                             prefecture_code: "神奈川県",
                                             address_city: "テスト市テスト町",
                                             address_street: "1-1-1",
                                             client_id: 1,
                                             )

SeedEstimateMatter2 = EstimateMatter.create!(title: "見積案件2",
                                             content: "見積案件2の内容",
                                             postal_code: "5940088",
                                             prefecture_code: "神奈川県",
                                             address_city: "テスト市テスト町",
                                             address_street: "1-1-1",
                                             client_id: 2,
                                             )                                          

puts "CREATE! ESTIMATE_MATTER"

SeedMatter1 = Matter.create!(title: "案件1",
                             content: "案件1の内容",
                             status: 0,
                             estimate_matter_id: SeedEstimateMatter1.id
                             )

SeedMatter2 = Matter.create!(title: "案件2",
                             content: "案件2の内容",
                             status: 0,
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
  Task.create!(title: "TASK#{ n + 1 }", status: 1, title: "当該タスク#{ n + 1 }", content: "テスト内容", sort_order: n, estimate_matter_id: SeedEstimateMatter1.id)
  Task.create!(title: "TASK#{ n + 1 }", status: 2, title: "進行中タスク#{ n + 1 }", content: "テスト内容", sort_order: n, estimate_matter_id: SeedEstimateMatter2.id)
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

puts "CREATE! ATTENDANCE"

SeedCategory1 = Category.create(name: "屋根", default: true)
SeedCategory2 = Category.create(name: "外壁", default: true)
SeedCategory3 = Category.create(name: "玄関", default: true)

puts "CREATE! CATEGORY"

3.times do |n|
  Material.create(name: "屋根素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory1.id)
  Material.create(name: "外壁素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory2.id)
  Material.create(name: "玄関素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory3.id)
end

puts "CREATE! MATERIAL"

3.times do |n|
  Construction.create(name: "屋根工事#{ n + 1 }", default: true, price: "100000", unit: "日", category_id: SeedCategory1.id)
  Construction.create(name: "外壁工事#{ n + 1 }", default: true, price: "150000", unit: "日", category_id: SeedCategory2.id)
  Construction.create(name: "玄関工事#{ n + 1 }", default: true, price: "150000", unit: "日", category_id: SeedCategory3.id)
end

puts "CREATE! CONSTRUCTION"

Certificate.create(title: "テスト診断書1", content: "テスト1", default: true, estimate_matter_id: SeedEstimateMatter1.id)
Certificate.create(title: "テスト診断書2", content: "テスト2", default: true, estimate_matter_id: SeedEstimateMatter2.id)

puts "CREATE! CERTIFICATE"

%w(タウンページ web 紹介).each do |name|
  AttractMethod.create(name: name)
end

puts "CREATE! ATTRACTIVE METHOD"
