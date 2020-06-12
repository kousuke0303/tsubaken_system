class ManagerUser < ApplicationRecord
  belongs_to :user
  belongs_to :manager
end
