class ConstructionSchedule < ApplicationRecord
  
  after_find :change_status, :reference_date
  
  belongs_to :matter
  belongs_to :supplier, optional: true
  has_many :construction_schedule_materials, dependent: :destroy
  has_many :materials, through: :construction_schedule_materials
  has_many :construction_schedule_images, dependent: :destroy
  has_many :images, through: :construction_schedule_images
  
  validates :title, presence: true
  validate :finished_on_is_before_today
  validate :necessary_of_started_on
  
  with_options on: :normal_commit do |normal_commit|
    normal_commit.validates :scheduled_started_on, presence: true
    normal_commit.validates :scheduled_finished_on, presence: true
    normal_commit.validate :scheduled_finished_on_is_after_started_on
  end
  
  attr_accessor :reference_date
  
  enum status: { not_started: 0, progress: 1, completed: 2 }
  
  scope :order_reference_date, ->{ sort_by{|construction_schedule| construction_schedule.reference_date}}
  
  
  def reference_date
    if started_on.present?
      if scheduled_started_on > started_on
        self.reference_date = started_on
      else
        self.reference_date = scheduled_started_on
      end
    elsif scheduled_started_on.present?
      self.reference_date = scheduled_started_on
    else
      self.reference_date = Date.current + 10.years
    end
  end
  
  def set_schedule
    estimate = self.estimate
    @estimate_info = estimate.estimate_details.left_joins(:material, :construction)
                                              .select('estimate_details.*, materials.name AS material_name, constructions.name AS construction_name')
  end
  
  def change_status
    if self.started_on.present? && self.finished_on.present?
      self.update(status: 2)
    elsif self.started_on.present?
      self.update(status: 1)
    else
      self.update(status: 0)
    end
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
    
    def finished_on_is_before_today
      if finished_on.present? && finished_on > Date.current
        errors.add(:finished_on, "は本日以降の日を設定できません")
      end
    end
    
    def necessary_of_started_on
      if finished_on.present? && started_on.nil?
        errors.add(:started_on, "着工日が登録されていません")
      end
    end
  
end
