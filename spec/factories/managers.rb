FactoryBot.define do
  factory :manager do
    name { "マネージャーテスト" }
    login_id { "MN-manager-9" }
    sequence(:department_id) { |n| "#{n}" }
    email { "test_length@test.com" }
    phone { "08011112222" }
    password { "password" }
    password_confirmation { "password" }
  end
end