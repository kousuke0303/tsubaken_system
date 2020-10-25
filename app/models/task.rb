class Task < ApplicationRecord
  belongs_to :matter
  
  enum status: {matter_task: 0, progress_tasks: 1, finished_tasks: 2}
  
  scope :are_matter_tasks, -> { where(status: "matter_tasks").order(:row_order) }
  scope :are_progress_tasks, -> { where(status: "progress_tasks").order(:row_order) }
  scope :are_finished_tasks, -> { where(status: "finished_tasks").order(:row_order) }

  scope :are_matter_tasks_for_commonly_used, -> { order(count: "DESC") }
end
