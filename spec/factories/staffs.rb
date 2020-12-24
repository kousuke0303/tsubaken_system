FactoryBot.define do
  factory :staff do
    name { "スタッフテスト" }
    sequence(:login_id) { |n| "ST-staff-#{n}" }
    sequence(:department_id) { |n| "#{n}" }
    postal_code { "1112222" }
    prefecture_code { "テスト県" }
    address_city { "テスト市" }
    address_street { "テスト町1-1-1" }
    email { "test_length@test.com" }
    phone { "08011112222" }
    password { "password" }
    password_confirmation { "password" }
  end
end
