class Task < ApplicationRecord
  belongs_to :matter, inverse_of: :tasks, optional: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 3000 }
  
  enum status: {default: 0, relevant: 1, progress: 2, finished: 3}
   
  scope :are_default, -> { default.order(:sort_order) }
  scope :are_relevant, -> { relevant.order(:sort_order) }
  scope :are_progress, -> { progress.order(:sort_order) }
  scope :are_finished, -> { finished.order(:sort_order) }

  # sort_orderを正しい連番に更新
  def self.rearranges(tasks)
    tasks.order(:sort_order).each_with_index do |task, index|
      task.update(sort_order: index)
    end
  end
end
