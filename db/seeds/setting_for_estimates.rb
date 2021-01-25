# 工事カテゴリ

SeedCategory1 = Category.create(name: "屋根", default: true)
SeedCategory2 = Category.create(name: "外壁", default: true)
SeedCategory3 = Category.create(name: "玄関", default: true)
SeedCategory4 = Category.create(name: "浴室", default: true)
SeedCategory5 = Category.create(name: "洗面所", default: true)
SeedCategory6 = Category.create(name: "リビング", default: true)
SeedCategory7 = Category.create(name: "キッチン", default: true)
SeedCategory8 = Category.create(name: "共通工事", default: true)
SeedCategory9 = Category.create(name: "付帯工事", default: true)

puts "CREATE! CATEGORY"

# 屋根素材
Material.create(name: "アレスダイナミックシーラーマイルド透明", service_life: "10年", price: 700, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create(name: "アレスダイナミックルーフ", service_life: "10年", price: 1200, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create(name: "ボンエポコートライト", service_life: "10年", price: 800, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create(name: "ボンフロン弱溶剤エナメルGT-SR", service_life: "10年", price: 1400, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create(name: "ガイナマルチシーラー弱溶剤", service_life: "10年", price: 700, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create(name: "ガイナ", service_life: "10年", price: 1400, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create(name: "ガイナ抗菌剤（１４kg用）", service_life: "10年", price: 9800, unit: "袋", default: true, category_id: SeedCategory1.id)
Material.create(name: "UVルーフプライマーsi", service_life: "10年", price: 900, unit: "㎡", default: true, category_id: SeedCategory1.id)
Material.create(name: "無機UVコートルーフ遮熱", service_life: "10年", price: 2200, unit: "㎡", default: true, category_id: SeedCategory1.id)

# 外壁素材
Material.create(name: "アレスダイナミックフィラー", service_life: "10年", price: 600, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create(name: "アレスダイナミックトップ", service_life: "10年", price: 900, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create(name: "ボンHBサーフェーサーR（W）", service_life: "10年", price: 700, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create(name: "ボンフロンマットGT-SR", service_life: "10年", price: 1200, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create(name: "ガイナ水性カチオンシーラー", service_life: "10年", price: 800, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create(name: "ガイナ", service_life: "10年", price: 1400, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create(name: "UVアンダーコートsi", service_life: "10年", price: 900, unit: "㎡", default: true, category_id: SeedCategory2.id)
Material.create(name: "無機UVコート溶剤遮熱", service_life: "10年", price: 1800, unit: "㎡", default: true, category_id: SeedCategory2.id)



# その他

3.times do |n|
  Material.create(name: "屋根素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory3.id)
  Material.create(name: "外壁素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory4.id)
  Material.create(name: "玄関素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory5.id)
  Material.create(name: "玄関素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory6.id)
  Material.create(name: "玄関素材#{ n + 1 }", service_life: "10年", price: 5000, unit: "枚", default: true, category_id: SeedCategory7.id)
end

puts "CREATE! MATERIAL"


# 工事内容

Construction.create(name: "足場仮設工事", default: true, price: 650, unit: "㎡", category_id: SeedCategory8.id)
Construction.create(name: "高圧洗浄", default: true, price: 30000, unit: "式", category_id: SeedCategory8.id)
Construction.create(name: "開口部三角打ち", default: true, price: 800, unit: "m", category_id: SeedCategory8.id)
Construction.create(name: "タスペーサー挿入", default: true, price: 30, unit: "個", category_id: SeedCategory8.id)
Construction.create(name: "タスマジック補修", default: true, price: 6000, unit: "式", category_id: SeedCategory8.id)
Construction.create(name: "FRP樹脂密着防水", default: true, price: 130000, unit: "式", category_id: SeedCategory8.id)
Construction.create(name: "雨樋防護ネット", default: true, price: 1600, unit: "m", category_id: SeedCategory8.id)
Construction.create(name: "樹木栽定・処分", default: true, price: 28000, unit: "式", category_id: SeedCategory8.id)

Construction.create(name: "軒天塗装", default: true, price: 1100, unit: "㎡", category_id: SeedCategory9.id)
Construction.create(name: "破風板・幕板・鼻隠し塗装", default: true, price: 900, unit: "m", category_id: SeedCategory9.id)
Construction.create(name: "雨樋塗装", default: true, price: 900, unit: "m", category_id: SeedCategory9.id)
Construction.create(name: "霧除け庇・出窓上部塗装", default: true, price: 3000, unit: "ヶ所", category_id: SeedCategory9.id)
Construction.create(name: "雨戸・戸袋塗装", default: true, price: 2800, unit: "㎡", category_id: SeedCategory9.id)
Construction.create(name: "水切り塗装", default: true, price: 18000, unit: "式", category_id: SeedCategory9.id)

3.times do |n|
  Construction.create(name: "屋根工事#{ n + 1 }", default: true, price: "100000", unit: "日", category_id: SeedCategory5.id)
  Construction.create(name: "外壁工事#{ n + 1 }", default: true, price: "150000", unit: "日", category_id: SeedCategory6.id)
  Construction.create(name: "玄関工事#{ n + 1 }", default: true, price: "150000", unit: "日", category_id: SeedCategory7.id)
end

puts "CREATE! CONSTRUCTION"
