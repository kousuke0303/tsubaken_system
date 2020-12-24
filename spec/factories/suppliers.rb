FactoryBot.define do
  factory :supplier do
    name { "外注先テスト" }
    kana { "がいちゅうさきてすと" }
    postal_code { "1112222" }
    prefecture_code { "テスト県" }
    address_city { "テスト市" }
    address_street { "テスト町1-1-1" }
    representative { "テスト太郎" }
    phone_1 { "08011112222" }
    phone_2 { "08022223333" }
    fax { "08011112222" }
    email{ "test_length@test.com" }
  end
end
