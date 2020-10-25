class Task < ApplicationRecord
  belongs_to :matter
  
  enum status: {matter_task: 0, progress_tasks: 1, finished_tasks: 2}
  
  scope :are_matter_tasks, -> { where(status: 0).order(:row_order) }
  scope :are_progress_tasks, -> { where(status: 1).order(:row_order) }
  scope :are_finished_tasks, -> { where(status: 2).order(:row_order) }

  scope :are_matter_tasks_for_commonly_used, -> { order(count: "DESC") }
end
