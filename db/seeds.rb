Admin.create!(name: "管理者",
              login_id: "AD-admin",
              password: "password",
              password_confirmation: "password")

puts "CREATE! ADMIN"

3.times do |n|
  Manager.create!(name: "マネージャー#{n}",
                  login_id: "MN-manager-#{n}",
                  phone: "08011112222",
                  email: "manager-#{n}@email.com",
                  password: "password",
                  password_confirmation: "password")
end

puts "CREATE! MANAGER"

3.times do |n|
  Staff.create!(name: "スタッフ#{n}",
                login_id: "ST-staff-#{n}",
                phone: "08011112222",
                email: "staff-#{n}@email.com",
                password: "password",
                password_confirmation: "password")
end

puts "CREATE! STAFF"

3.times do |n|
  Supplier.create!(name: "テスト外注先#{n}",
                  kana: "テストガイチュウサキ",
                  phone_1: "08054545454",
                  email: "testsupplier-#{n}@email.com",
                  zip_code: "5940088",
                  address: "大阪府テスト市")
end

puts "CREATE! Supplier"

3.times do |n|
ExternalStaff.create!(name: "外部スタッフ#{n}",
                      kana: "ガイブスタッフ",
                      login_id: "SP1-sup-#{n}",
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
  Client.create!(name: "テスト顧客#{n}",
                login_id: "CL-client-#{n}",
                phone_1: "08011112222",
                phone_2: "08011113333",
                email: "client-#{n}@email.com",
                zip_code: "5940088",
                address: "大阪府テスト市",
                password: "password",
                password_confirmation: "password")
end

puts "CREATE! CLIENT"

first_day = Date.current.beginning_of_month
last_day = first_day.end_of_month
one_month = [*first_day..last_day]
today = Date.current
year = today.year
month = today.month
day = today.day
Manager.all.each do |manager|
  one_month.each { |day| manager.attendances.create!(worked_on: day) }
  manager.attendances.find_by(worked_on: Date.current).update_attributes!(started_at: "#{year}-#{month}-#{day} 09:00:00",
                                                                          finished_at: "#{year}-#{month}-#{day} 17:00:00")
end

Staff.all.each do |staff|
  one_month.each { |day| staff.attendances.create!(worked_on: day) }
  staff.attendances.find_by(worked_on: Date.current).update_attributes!(started_at: "#{year}-#{month}-#{day} 09:00:00",
                                                                        finished_at: "#{year}-#{month}-#{day} 17:00:00")
end

ExternalStaff.all.each do |external_staff|
  one_month.each { |day| external_staff.attendances.create!(worked_on: day) }
  external_staff.attendances.find_by(worked_on: Date.current).update_attributes!(started_at: "#{year}-#{month}-#{day} 09:00:00",
                                                                                 finished_at: "#{year}-#{month}-#{day} 17:00:00")
end

puts "CREATE! ATTENDANCES"
