class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 3000 }

  belongs_to :matter, inverse_of: :tasks, optional: true
  
  enum status: {default: 0, relevant: 1, progress: 2, finished: 3}
   
  scope :are_default, -> { default.order(:row_order) }
  scope :are_relevant, -> { relevant.order(:row_order) }
  scope :are_progress, -> { progress.order(:row_order) }
  scope :are_finished, -> { finished.order(:row_order) }
end
