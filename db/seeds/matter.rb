# 営業案件からの案件作成
estimate_matters_for_matter = EstimateMatter.all.order(:created_at).each_slice(3).map(&:first)
estimate_matters_for_matter.each do |est|
  estimate_id = est.estimates.first.id
  Matter.create!(est.attributes.merge(
                             scheduled_started_on: Date.today,
                             scheduled_finished_on: Date.today + 7.day,
                             created_at: est.created_at + 7.day,
                             estimate_id: estimate_id,
                             estimate_matter_id: est.id
                             ))
  contract_status = est.sales_statuses.new(status: 6, 
                                           member_code_id: est.member_codes.first.id,
                                           scheduled_date: est.matter.created_at)
  contract_status.login_user = Admin.first
  contract_status.save!
  
end

puts "CREATE! MATTER"


# -----------------------------------------------------
      # TASK
# -----------------------------------------------------

Matter.all.each_with_index do |matter, index|
  task_1 = Task.new(status: 1, title: "当該タスク#{ index + 1 }", content: "テスト内容", sort_order: index + 3, matter_id: matter.id)
  task_1.save!
  task_2 = Task.new(status: 2, title: "進行中タスク#{ index + 1 }", content: "テスト内容", sort_order: index + 4, matter_id: matter.id)
  task_2.save!
end

puts "CREATE! TASK"
