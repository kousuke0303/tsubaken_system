# 営業案件からの案件作成
estimate_matters_for_matter = EstimateMatter.all.order(:created_at).each_slice(3).map(&:first)
estimate_matters_for_matter.each do |est|
  estimate_id = est.estimates.first.id
  est.create_matter(est.attributes.merge(
                    scheduled_started_on: Date.today,
                    scheduled_finished_on: Date.today + 7.day,
                    created_at: est.created_at + 7.day,
                    estimate_id: estimate_id
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
