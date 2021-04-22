class ConstructionSchedule < ApplicationRecord
  
  belongs_to :matter
  belongs_to :supplier, optional: true
  
  validates :title, presence: true
  validates :scheduled_started_on, presence: true
  validates :scheduled_finished_on, presence: true
  validate :scheduled_finished_on_is_after_started_on
  
  scope :order_started_on, ->{ order(:scheduled_started_on)}
  
  def scheduled_started_on_disp
    self.scheduled_started_on.strftime('%-m月%-d日')
  end
  
  def scheduled_finished_on_disp
    self.scheduled_finished_on.strftime('%-m月%-d日')
  end
  
  private
  #----------------------------------------------
    #VALIDATION_METHOD
  #---------------------------------------------
    
    def scheduled_finished_on_is_after_started_on
      if scheduled_started_on.present? && scheduled_finished_on.present? && scheduled_started_on >= scheduled_finished_on
        errors.add(:scheduled_finished_on, "は開始予定時刻以降を入力してください") 
      end
    end
  
  
end
