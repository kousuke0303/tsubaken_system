class Staffs::Attendance < ApplicationRecord
  belongs_to :staff
  belongs_to :matter
end
