FactoryBot.define do
  factory :manager do
    name { "マネージャーテスト" }
    login_id { "MN-manager-9" }
    sequence(:department_id) { |n| "#{n}" }
    email { "test_length@test.com" }
    phone { "08011112222" }
    postal_code { "1112222" }
    prefecture_code { "テスト県" }
    address_city { "テスト市" }
    address_street { "テスト町1-1-1" }
    password { "password" }
    password_confirmation { "password" }
  end
end
