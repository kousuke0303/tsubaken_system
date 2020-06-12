class ManagerStaff < ApplicationRecord
  belongs_to :staff
  belongs_to :manager
end
