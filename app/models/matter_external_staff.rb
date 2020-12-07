class MatterExternalStaff < ApplicationRecord
  belongs_to :matter
  belongs_to :external_staff
end
