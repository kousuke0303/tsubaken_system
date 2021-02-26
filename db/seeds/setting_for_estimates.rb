# 発行元

Publisher.create!(name: "AZABU", postal_code: "5489494", prefecture_code: "東京都", address_city: "杉並区", address_street: "1-1", phone: "0611111111")
Publisher.create!(name: "発行元B", postal_code: "5489494", prefecture_code: "東京都", address_city: "杉並区", address_street: "1-1", phone: "0611112222")
Publisher.create!(name: "発行元C", postal_code: "5489494", prefecture_code: "東京都", address_city: "杉並区", address_street: "1-1", phone: "0611113333")
Publisher.create!(name: "発行元D", postal_code: "5489494", prefecture_code: "東京都", address_city: "杉並区", address_street: "1-1", phone: "0611114444")

publisher = Publisher.find(1)
publisher.image.attach(io: File.open('app/assets/images/logo_image.png'), filename: 'logo_image.png')

# 工事名称

SeedCategory1 = Category.create!(name: "屋根")
SeedCategory2 = Category.create!(name: "外壁")
SeedCategory3 = Category.create!(name: "玄関")
SeedCategory4 = Category.create!(name: "浴室")
SeedCategory5 = Category.create!(name: "洗面所")
SeedCategory6 = Category.create!(name: "リビング")
SeedCategory7 = Category.create!(name: "キッチン")
SeedCategory8 = Category.create!(name: "共通工事")
SeedCategory9 = Category.create!(name: "付帯工事")

puts "CREATE! CATEGORY"

# 屋根素材
Material.create!(name: "アレスダイナミックシーラーマイルド透明", service_life: "10年", price: 700, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create!(name: "アレスダイナミックルーフ", service_life: "10年", price: 1200, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create!(name: "ボンエポコートライト", service_life: "10年", price: 800, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create!(name: "ボンフロン弱溶剤エナメルGT-SR", service_life: "10年", price: 1400, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create!(name: "ガイナマルチシーラー弱溶剤", service_life: "10年", price: 700, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create!(name: "ガイナ", service_life: "10年", price: 1400, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create!(name: "ガイナ抗菌剤（１４kg用）", service_life: "10年", price: 9800, unit: "袋", default: true, category_id: SeedCategory1.id)
Material.create!(name: "UVルーフプライマーsi", service_life: "10年", price: 900, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create!(name: "無機UVコートルーフ遮熱", service_life: "10年", price: 2200, unit: "㎡", default: true, category_id: SeedCategory1.id)

# 外壁素材
Material.create!(name: "アレスダイナミックフィラー", service_life: "10年", price: 600, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create!(name: "アレスダイナミックトップ", service_life: "10年", price: 900, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create!(name: "ボンHBサーフェーサーR（W）", service_life: "10年", price: 700, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create!(name: "ボンフロンマットGT-SR", service_life: "10年", price: 1200, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create!(name: "ガイナ水性カチオンシーラー", service_life: "10年", price: 800, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create!(name: "ガイナ", service_life: "10年", price: 1400, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create!(name: "UVアンダーコートsi", service_life: "10年", price: 900, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create!(name: "無機UVコート溶剤遮熱", service_life: "10年", price: 1800, unit: "㎡", default: true, category_id: SeedCategory2.id)

# その他

3.times do |n|
  Material.create!(name: "屋根素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory3.id)
  Material.create!(name: "外壁素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory4.id)
  Material.create!(name: "玄関素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory5.id)
  Material.create!(name: "玄関素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory6.id)
  Material.create!(name: "玄関素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory7.id)
end

puts "CREATE! MATERIAL"


# 工事内容

Construction.create!(name: "足場仮設工事", default: true, price: 650, unit: "㎡", category_id: SeedCategory8.id)
Construction.create!(name: "高圧洗浄", default: true, price: 30000, unit: "式", category_id: SeedCategory8.id)
Construction.create!(name: "開口部三角打ち", default: true, price: 800, unit: "m", category_id: SeedCategory8.id)
Construction.create!(name: "タスペーサー挿入", default: true, price: 30, unit: "個", category_id: SeedCategory8.id)
Construction.create!(name: "タスマジック補修", default: true, price: 6000, unit: "式", category_id: SeedCategory8.id)
Construction.create!(name: "FRP樹脂密着防水", default: true, price: 130000, unit: "式", category_id: SeedCategory8.id)
Construction.create!(name: "雨樋防護ネット", default: true, price: 1600, unit: "m", category_id: SeedCategory8.id)
Construction.create!(name: "樹木栽定・処分", default: true, price: 28000, unit: "式", category_id: SeedCategory8.id)

Construction.create!(name: "軒天塗装", default: true, price: 1100, unit: "㎡", category_id: SeedCategory9.id)
Construction.create!(name: "破風板・幕板・鼻隠し塗装", default: true, price: 900, unit: "m", category_id: SeedCategory9.id)
Construction.create!(name: "雨樋塗装", default: true, price: 900, unit: "m", category_id: SeedCategory9.id)
Construction.create!(name: "霧除け庇・出窓上部塗装", default: true, price: 3000, unit: "ヶ所", category_id: SeedCategory9.id)
Construction.create!(name: "雨戸・戸袋塗装", default: true, price: 2800, unit: "㎡", category_id: SeedCategory9.id)
Construction.create!(name: "水切り塗装", default: true, price: 18000, unit: "式", category_id: SeedCategory9.id)

3.times do |n|
  Construction.create!(name: "屋根工事#{ n + 1 }", default: true, price: "100000", unit: "日", category_id: SeedCategory5.id)
  Construction.create!(name: "外壁工事#{ n + 1 }", default: true, price: "150000", unit: "日", category_id: SeedCategory6.id)
  Construction.create!(name: "玄関工事#{ n + 1 }", default: true, price: "150000", unit: "日", category_id: SeedCategory7.id)
end

puts "CREATE! CONSTRUCTION"

# プラン名
plan_name_array = [["シリコン", 3], ["チッ素", 2], ["断熱ガイナ", 4], ["無機", 5]]
plan_name_array.each do |array|
  PlanName.create!(name: array[0], label_color_id: array[1])
end

puts "CREATE! PlANNAME"

# 集客方法
%w[web 訪問販売 チラシ広告 紹介 タウンページ].each do |name|
  AttractMethod.create(name: name)
end

puts "CREATE! ATTRACTIVE METHOD"

# --------------------------------------------------
 # 診断書関連
# -------------------------------------

%w(屋根 外壁 玄関 浴室 洗面所 リビング キッチン).each do |name|
  Certificate.create(title: "#{ name }", content: "#{ name }の診断内容", default: true)
end 

puts "CREATE! CERTIFICATE"

content = "「美観」だけの工事は「リペア」「化粧直し」などと呼ばれます。\n美観だけの工事で本当に満足されますか？\n弊社では、より革新的な「改修」「リノベーション」をご提案させていただきます。\n大切な「資産」を塗装で守る!!\n目指すは、「３世代 １００年安心リノベーション」"

Cover.create!(title: "typeA", content: content, default: true)

puts "CREATE! COVER"