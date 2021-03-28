class Task < ApplicationRecord
  belongs_to :estimate_matter, optional: true
  belongs_to :matter, optional: true
  belongs_to :member_code, optional: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 300 }
  # validate :only_in_charge
  
  before_save :member_name_update
  
  enum status: { default: 0, relevant: 1, ongoing: 2, finished: 3 }
   
  scope :are_default, -> { default.order(default_task_id_count: :desc) }
  scope :are_relevant, -> { relevant.order(:sort_order) }
  scope :are_ongoing, -> { ongoing.order(:sort_order) }
  scope :are_finished, -> { finished.order(:sort_order) }
  
  
  #-----------------------------------------------------
    # INSTANCE_METHOD
  #-----------------------------------------------------

  # sort_orderを正しい連番に更新
  def self.reload_sort_order(tasks)
    tasks.order(:sort_order).each_with_index do |task, index|
      task.update(sort_order: index)
    end
  end

  # sort_orderを+1に更新
  def self.increment_sort_order(matter, status, sort_order)
    matter.tasks.where("status >= ?", status).where("sort_order >= ?", sort_order).each do |task|
      new_sort_order = task.sort_order.to_i + 1
      task.update(sort_order: new_sort_order)
    end
  end

  # sort_orderを-1に更新
  def self.decrement_sort_order(matter, status, sort_order)
    matter.tasks.where("status >= ?", status).where("sort_order <= ?", sort_order).each do |task|
      unless task.sort_order == 0
        new_sort_order = task.sort_order.to_i - 1
        task.update(sort_order: new_sort_order)
      end
    end
  end
  
  # 使用回数を保存
  def self.count_default_tasks(default_tasks)
    default_tasks.each do |default_task|
      count = Task.where("default_task_id = ?", default_task.default_task_id).count - 1
      default_task.update(default_task_id_count: count)
    end
  end
  
  private
  
  #-----------------------------------------------------
    # VALIDATION_METHOD
  #-----------------------------------------------------
  
  # 担当者は一名に制限
  def only_in_charge
    errors.add(:base, "担当者は一名までです") if self.staff && self.external_staff
  end
  
  
  #-----------------------------------------------------
    # CALLBACK_METHOD
  #-----------------------------------------------------
  
  def member_name_update
    if self.member_code.present?
      member_code = MemberCode.find(self.member_code_id)
      self.member_name = member_code.member_name_from_member_code
    end
  end
end
