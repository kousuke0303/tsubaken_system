class ManagerTask < ApplicationRecord
  belongs_to :manager
  belongs_to :task
end
