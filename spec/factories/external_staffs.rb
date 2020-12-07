FactoryBot.define do
  factory :external_staff do
    name { "外部スタッフテスト" }
    kana { "がいぶすたっふてすと" }
    sequence(:supplier_id) { |n| "#{n}" }
    sequence(:login_id) { |n| "SP#{supplier_id}-sup-#{n}" }
    phone { "08011112222" }
    email { "test_length@test.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
