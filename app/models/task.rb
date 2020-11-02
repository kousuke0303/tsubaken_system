class Task < ApplicationRecord
  belongs_to :matter, inverse_of: :tasks, optional: true
   after_initialize :set_default_task, if: :new_record?
  
  enum status: {default_tasks: 0, matter_tasks: 1, progress_tasks: 2, finished_tasks: 3}
   
  scope :are_default_tasks, -> { where(status: "default_tasks").order(:row_order) }
  scope :are_matter_tasks, -> { where(status: "matter_tasks").order(:row_order) }
  scope :are_progress_tasks, -> { where(status: "progress_tasks").order(:row_order) }
  scope :are_finished_tasks, -> { where(status: "finished_tasks").order(:row_order) }
  
  private
    def set_default_task
      self.status ||= "default_tasks"
    end
end
