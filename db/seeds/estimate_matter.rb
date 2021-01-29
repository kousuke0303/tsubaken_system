# 営業案件
Client.all.each.with_index(1) do |client, index|
  new_est = EstimateMatter.create!(title: "#{client.name} 邸",
                           content: "屋根・外壁塗装工事",
                           postal_code: client.postal_code,
                           prefecture_code: client.prefecture_code,
                           address_city: client.address_city,
                           address_street: client.address_street,
                           client_id: index,
                           publisher_id: rand(1..4),
                           created_at: Date.today - rand(1..24).month
                         )
  EstimateMatterStaff.create!(estimate_matter_id: new_est.id, staff_id: rand(1..3))
  EstimateMatterExternalStaff.create!(estimate_matter_id: new_est.id, external_staff_id: rand(1..3))
end

puts "CREATE! ESTIMATE_MATTER"



# 営業案件ステータス
EstimateMatter.all.each do |est|
  new_sales_status = est.sales_statuses.create!(status: rand(14),
                                                conducted_on: est.created_at + 10.days
                                               )
                            
  SalesStatusEditor.create!(authority: "manager",
                             member_id: rand(1..3),
                             sales_status_id: new_sales_status.id)
  SalesStatusMember.create!(authority: "staff",
                             member_id: est.staffs.first.id,
                             sales_status_id: new_sales_status.id)
end

# 営業案件からの案件作成
EstimateMatter.where(id: 1..25).each do |est|
 Matter.create!(title: est.title,
                content: est.content,
                status: 0,
                estimate_matter_id: est.id
               )
end
puts "CREATE! MATTER"

# -----------------------------------------------------
      # TASK
# -----------------------------------------------------

3.times do |n|
  Task.create!(status: 0, title: "DEFALTE_TASK_#{ n + 1 }", content: "テスト内容", sort_order: n, default_task_id: "#{ n + 1 }")
end

puts "CREATE! DEFALTE_TASK"


Matter.all.each_with_index do |matter, index|
  Task.create!(status: 1, title: "当該タスク#{ index + 1 }", content: "テスト内容", sort_order: index, matter_id: matter.id)
  Task.create!(status: 2, title: "進行中タスク#{ index + 1 }", content: "テスト内容", sort_order: index, matter_id: matter.id)
end

puts "CREATE! TASK"
