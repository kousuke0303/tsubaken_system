FactoryBot.define do
  factory :admin do
    name { "AD-admin-T" }
    login_id { "AD-admin" }
    phone { "09011112222" }
    email { "test_length@test.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
