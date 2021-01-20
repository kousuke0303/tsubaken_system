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
                  postal_code: "1112222",
                  prefecture_code: "テスト県",
                  address_city: "テスト市",
                  address_street: "テスト町1-1-1",
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
                postal_code: "1112222",
                prefecture_code: "テスト県",
                address_city: "テスト市",
                address_street: "テスト町1-1-1",
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
                      login_id: "ES-exstaff#{ n + 1 }",
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

require "./db/seeds/estimate_matter.rb"

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
                                                                          finished_at: "#{year}-#{month}-#{day} 17:13:23")
end

Staff.all.each do |staff|
  one_month.each { |day| staff.attendances.create!(worked_on: day) }
  staff.attendances.find_by(worked_on: Date.current).update(started_at: "#{year}-#{month}-#{day} 09:00:00",
                                                                        finished_at: "#{year}-#{month}-#{day} 17:13:23")
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

%w(屋根 外壁 玄関).each do |name|
  Certificate.create(title: "診断書#{ name }の診断書", content: "#{ name }の診断内容", default: true)
end 

puts "CREATE! CERTIFICATE"

%w(タウンページ web 紹介).each do |name|
  AttractMethod.create(name: name)
end

puts "CREATE! ATTRACTIVE METHOD"
