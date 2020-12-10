FactoryBot.define do
  factory :supplier do
    name { "外注先テスト" }
    kana { "がいちゅうさきてすと" }
    zip_code { "1112222" }
    representative { "テスト太郎" }
    address { "テスト県テスト市1-1-1" }
    phone_1 { "08011112222" }
    phone_2 { "08022223333" }
    fax { "08011112222" }
    email{ "test_length@test.com" }
  end
end
