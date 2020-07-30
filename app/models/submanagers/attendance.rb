class Submanagers::Attendance < ApplicationRecord
  belongs_to :submanager
  belongs_to :matter
end
