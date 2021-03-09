LabelColor.create(name: "パープル", color_code: "#8695d6")
LabelColor.create(name: "ブルー", color_code: "#007bff")
LabelColor.create(name: "ピンク", color_code: "#d686bd")
LabelColor.create(name: "ブラウン", color_code: "#8a7a74")
LabelColor.create(name: "グレー", color_code: "#b7b7b7")

# 設定/見積関係
require "./db/seeds/setting_for_estimates.rb"

%w[無所属 営業 経理].each do |name|
  Department.create!(name: name)
end

puts "CREATE! DEPARTMENT"

Admin.create!(name: "管理者", login_id: "AD-admin", password: "password", password_confirmation: "password")
admin = Admin.first
admin.avator.attach(io: File.open('app/assets/images/admin_avator.jpg'), filename: 'admin_avator.jpg')
puts "CREATE! ADMIN"

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
                label_color_id: rand(5) + 1,
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
                      login_id: "ES-exstaff-#{ n + 1 }",
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

# -------------------------------------------------------------
   # クライアント
# ------------------------------------------------------------
prefectures = %w[東京都 神奈川県 栃木県 千葉県 茨城県]
str_array = %w[山 川 田 森 林 木]
30.times do |n|
  gimei = Gimei.name
  name = gimei.kanji
  kana = "#{ gimei.last.katakana }　#{ gimei.first.katakana }"
  Client.create!(name: name,
                 kana: kana,
                 login_id: "CL-cccc-#{ n + 1 }",
                 phone_1: "080" + (0...8).map{ (0..9).to_a[rand(10)] }.join,
                 phone_2: "080" + (0...8).map{ (0..9).to_a[rand(10)] }.join,
                 email: "client-#{ n + 1 }@email.com",
                 postal_code: "1234567",
                 prefecture_code: prefectures[rand(5)],
                 address_city: str_array[rand(6)],
                 address_street: "1-1-#{ n + 1 }",
                 password: "password",
                 password_confirmation: "password")
end

puts "CREATE! CLIENT"

# -----------------------------------------------------
      # 営業案件及び案件関連
# -----------------------------------------------------

require "./db/seeds/estimate_matter.rb"
require "./db/seeds/estimate.rb"

# -----------------------------------------------------
      # Attendance
# -----------------------------------------------------

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

3.times do |n|
  client = Client.find(n + 1)
  Inquiry.create(kind: 0, name: client.name, kana: client.kana, email: client.email, phone: client.phone_1, reply_email: client.email)
end

puts "CREATE! INQUIRY"

# -----------------------------------------------------
      # SCHEDULE
# -----------------------------------------------------

require "./db/seeds/schedule.rb"
