FactoryBot.define do
  factory :staff do
    name { "スタッフテスト" }
    sequence(:login_id) { |n| "ST-staff-#{n}" }
    sequence(:department_id) { |n| "#{n}" }
    email { "test_length@test.com" }
    phone { "08011112222" }
    password { "password" }
    password_confirmation { "password" }
  end
end
