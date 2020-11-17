class MatterStaff < ApplicationRecord
  belongs_to :matter, inverse_of: :matter_staffs
  belongs_to :staff
end
