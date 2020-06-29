class Attendance < ApplicationRecord
  belongs_to :submanager
  belongs_to :staff
  belongs_to :matter
end
