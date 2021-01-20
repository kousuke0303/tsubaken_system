SeedEstimateMatter1 = EstimateMatter.create!(title: "見積案件1",
                                             content: "見積案件1の内容",
                                             postal_code: "5940088",
                                             prefecture_code: "神奈川県",
                                             address_city: "テスト市テスト町",
                                             address_street: "1-1-1",
                                             client_id: 1,
                                             )
SeedEstimateMatter1.update!(created_at: Date.current.prev_month)
SeedEstimateMatter1.sales_statuses.create!(status: "not_set", conducted_on: Date.current)

SeedEstimateMatter2 = EstimateMatter.create!(title: "見積案件2",
                                             content: "見積案件2の内容",
                                             postal_code: "5940088",
                                             prefecture_code: "神奈川県",
                                             address_city: "テスト市テスト町",
                                             address_street: "1-1-1",
                                             client_id: 2,
                                             )
                                             
SeedEstimateMatter2.sales_statuses.create!(status: "not_set", conducted_on: Date.current)                                             

puts "CREATE! ESTIMATE_MATTER"

EstimateMatterStaff.create!(estimate_matter_id: SeedEstimateMatter1.id, staff_id: 1)
EstimateMatterStaff.create!(estimate_matter_id: SeedEstimateMatter2.id, staff_id: 2)

puts "CREATE! ESTIMATE_MATTER_STAFF"

EstimateMatterExternalStaff.create!(estimate_matter_id: SeedEstimateMatter1.id, external_staff_id: 1)
EstimateMatterExternalStaff.create!(estimate_matter_id: SeedEstimateMatter2.id, external_staff_id: 2)

puts "CREATE! ESTIMATE_MATTER_EXTERNAL_STAFF"

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

MatterStaff.create!(matter_id: SeedMatter1.id, staff_id: 1)
MatterStaff.create!(matter_id: SeedMatter2.id, staff_id: 2)

puts "CREATE! MATTER_STAFF"

MatterExternalStaff.create!(matter_id: SeedMatter1.id, external_staff_id: 1)
MatterExternalStaff.create!(matter_id: SeedMatter2.id, external_staff_id: 2)

puts "CREATE! MATTER_EXTERNAL_STAFF"

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
