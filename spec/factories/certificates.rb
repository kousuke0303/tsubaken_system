FactoryBot.define do
  factory :certificate do
    title { "MyString" }
    content { "MyString" }
    default { false }
    image_id { 1 }
    message_id { 1 }
  end
end
