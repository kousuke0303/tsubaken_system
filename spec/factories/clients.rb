FactoryBot.define do
  factory :client do
    name { "顧客テスト" }
    kana { "こきゃくてすと" }
    gender { 0 }
    phone_1 { "08011112222" }
    phone_2 { "08022223333" }
    fax { "08011112222" }
    email{ "test_length@test.com" }
    birthed_on { "19991010" }
    postal_code { "1112222" }
    prefecture_code { "テスト県" }
    address_city { "テスト市" }
    address_street { "テスト町1-1-1" }
    sequence(:login_id) { |n| "CL-client-#{n}" }
    password { "password" }
    password_confirmation { "password" }
  end
end
