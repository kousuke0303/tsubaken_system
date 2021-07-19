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
                                  attract_method_id: rand(2..5),
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