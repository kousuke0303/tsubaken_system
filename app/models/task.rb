class Task < ApplicationRecord
  has_many :matter_tasks, dependent: :destroy
  has_many :matters, through: :matter_tasks
  
  has_many :manager_tasks, dependent: :destroy
  has_many :managers, through: :manager_tasks
end
