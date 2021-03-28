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
                                  attract_method_id: rand(1..5),
                                  created_at: Date.current - rand(0..23).month
                                  )
  EstimateMatterMemberCode.create!(estimate_matter_id: new_est.id, member_code_id: rand(5..6))
  EstimateMatterMemberCode.create!(estimate_matter_id: new_est.id, member_code_id: rand(8..9))
end

puts "CREATE! ESTIMATE_MATTER"



# 営業案件ステータス
EstimateMatter.all.each do |est|
  new_sales_status = est.sales_statuses.new(status: rand(14),
                                            scheduled_date: est.created_at + 10.days,
                                            register_for_schedule: 0,
                                            member_code_id: est.estimate_matter_member_codes.first.member_code_id)
  new_sales_status.login_user = Admin.find(1)
  new_sales_status.save!
end

puts "CREATE! SALES_STATUS"

# 営業案件からの案件作成
estimate_matters_for_matter = EstimateMatter.all.order(:created_at).each_slice(3).map(&:first)
estimate_matters_for_matter.each do |est|
  est.create_matter(est.attributes.merge(
                    scheduled_started_on: Date.today,
                    scheduled_finished_on: Date.today + 7.day,
                    created_at: est.created_at + 7.day
                    ))
end

puts "CREATE! MATTER"


# -----------------------------------------------------
      # TASK
# -----------------------------------------------------

Task.create!(status: 0, title: "現場清掃", content: "掃除", sort_order: 1, default_task_id: 1)
Task.create!(status: 0, title: "近隣挨拶", content: "隣の家に挨拶", sort_order: 2, default_task_id: 2)
puts "CREATE! DEFALTE_TASK"


Matter.all.each_with_index do |matter, index|
  task_1 = Task.new(status: 1, title: "当該タスク#{ index + 1 }", content: "テスト内容", sort_order: index + 3, matter_id: matter.id)
  task_1.member_code_id = matter.member_codes.first.id
  task_1.save!
  task_2 = Task.new(status: 2, title: "進行中タスク#{ index + 1 }", content: "テスト内容", sort_order: index + 4, matter_id: matter.id)
  task_2.member_code_id = matter.member_codes.first.id
  task_2.save!
end

puts "CREATE! TASK"
