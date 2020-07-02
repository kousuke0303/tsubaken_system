class Task < ApplicationRecord
  has_many :matter_tasks, dependent: :destroy
  has_many :matters, through: :matter_tasks
  
  has_many :manager_tasks, dependent: :destroy
  has_many :managers, through: :manager_tasks
  
  scope :are_matter_tasks, -> { where(status: "matter_tasks").order(:row_order) }
  scope :are_progress_tasks, -> { where(status: "progress_tasks").order(:row_order) }
  scope :are_finished_tasks, -> { where(status: "finished_tasks").order(:row_order) }
  # よく使用される順
  scope :are_matter_tasks_for_commonly_used, -> { order("count DESC") }
  
end
