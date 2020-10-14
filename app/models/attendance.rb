class Attendance < ApplicationRecord
  belongs_to :manager, optional: true
  belongs_to :staff, optional: true
  belongs_to :external_staff, optional: true
end
