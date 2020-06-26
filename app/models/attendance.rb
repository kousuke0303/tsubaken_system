class Attendance < ApplicationRecord
  belongs_to :subumanager
  belongs_to :staff
end
