class MatterStaff < ApplicationRecord
  belongs_to :matter
  belongs_to :staff
end
