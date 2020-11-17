FactoryBot.define do
  factory :attendance do
    worked_on { "2020-10-14" }
    started_at { "2020-10-14 16:46:01" }
    finished_at { "2020-10-14 16:46:01" }
    manager { nil }
    staff { nil }
    external_staff { nil }
  end
end
