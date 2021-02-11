est = EstimateMatter.all
est.each do |est|
  plan_name = PlanName.all.find(rand(1..4))
  est.estimates.create!(title: plan_name.name,
                        plan_name_id: plan_name.id,
                       )
end

puts "CREATE! ESTIMATE"

estimate_1 = Estimate.all
estimate_1.each do |estimate|
  category = Category.find(rand(1..2))
  material = Material.find(rand(1..9))
  construction = Construction.find(rand(1..8))
  seed_detail_material = estimate.estimate_details.create!(category_id: category.id,
                                    category_name: category.name,
                                    material_id: material.id,
                                    material_name: material.name,
                                    price: material.price,
                                    unit: material.unit,
                                    amount: rand(10..100)
                                    )
  seed_detail_material.update(total: seed_detail_material.price * seed_detail_material.amount)
  seed_detail_construction = estimate.estimate_details.create!(category_id: category.id,
                                    category_name: category.name,
                                    construction_id: construction.id,
                                    construction_name: construction.name,
                                    price: construction.price,
                                    unit: construction.unit,
                                    amount: rand(1..10)
                                    )
  seed_detail_construction.update(total: seed_detail_construction.price * seed_detail_construction.amount)
  
  if estimate.estimate_matter.matter.present?
    estimate.update(total_price: estimate.estimate_details.sum(:total),
                    matter_id: estimate.estimate_matter.matter.id)
  else
    estimate.update(total_price: estimate.estimate_details.sum(:total))
  end
end


puts "CREATE! ESTIMATEDETAIL"