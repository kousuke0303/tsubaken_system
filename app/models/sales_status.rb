class SalesStatus < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :member_code, optional: true
  
  has_one :schedule, dependent: :destroy
  has_one :sales_status_editor, dependent: :destroy
  
  attr_accessor :login_user
  
  validates :status, presence: true
  validates :scheduled_date, presence: true
  validates :note, length: { maximum: 300 }
  validate :scheduled_end_time_is_after_start_time
  validate :except_duplicate_schedule, on: :schedule_register
  validate :except_duplicate_schedule_for_update, on: :schedule_update
  validates :scheduled_start_time, presence: true, on: [:schedule_register, :schedule_update]
  validates :scheduled_end_time, presence: true, on: [:schedule_register, :schedule_update]
  
  before_save :member_name_update
  after_commit :create_editor, on: :create
  after_commit :update_editor, on: :update
  
  # 成約見積案件
  scope :contracted_estimate_matter, -> (estimate_matter_id) { joins(:estimate_matter)
                                        .where("(estimate_matter_id = ?)", estimate_matter_id)
                                        .where("(status = ?)", 6) }

  enum status: { not_set: 0, other: 1, appointment: 2, inspection: 3, calculation: 4, immediately: 5, contract: 6, contemplation_month: 7,
                 contemplation_year: 8, lost: 9, lost_by_other: 10, chasing: 11, waiting_insurance: 12, consideration: 13, start_of_construction: 14 }
  
  enum register_for_schedule: { not_register: 0, schedule_register: 1, schedule_update: 2, schedule_destroy: 3 }
  
  # updateでcontextを指定できるように変更
  def update_with_context(attributes, context)
    with_transaction_returning_status do
      assign_attributes(attributes)
      save!(context: context)
    end
  end
  
  def set_schedule
    ActiveRecord::Base.transaction do
      self.save!(context: :schedule_register)
      schedule_create
    end
  end
  
  def update_and_set_schedule(update_params)
    ActiveRecord::Base.transaction do
      self.update_with_context(update_params, :schedule_register)
      schedule_create
    end
  end
  
  def update_and_update_schedule(update_params, schedule)
    ActiveRecord::Base.transaction do
      self.update_with_context(update_params, :schedule_register)
      schedule_update(schedule)
    end
  end
  
  def update_and_destroy_schedule(update_params, schedule)
    ActiveRecord::Base.transaction do
      self.update!(update_params)
      schedule_destroy(schedule)
    end
  end
  
  def schedule_create
    Schedule.create!(copy_attributes.merge(sales_status_id: self.id))
  end
  
  def schedule_update(schedule)
    schedule.update_attributes!(copy_attributes)
  end
  
  def schedule_destroy(schedule)
    schedule.destroy!
  end
  
  def copy_attributes
    title = self.status_i18n + "/" + self.estimate_matter.title
    params_hash = self.attributes
    params_hash.delete("id")
    params_hash.delete("estimate_matter_id")
    params_hash.delete("status")
    params_hash.delete("register_for_schedule")
    params_hash.delete("member_name")
    params_hash.store("title", title)
    return params_hash
  end
  
  
  private
 
    def scheduled_end_time_is_after_start_time
      if scheduled_start_time.present? && scheduled_end_time.present? && scheduled_start_time >= scheduled_end_time
        errors.add(:scheduled_end_time, "は開始予定時刻以降を入力してください") 
      end
    end
    
    # 重複スケジュール登録拒否
    def except_duplicate_schedule
      duplicate_schedule = Schedule.where(member_code_id: self.member_code_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
      if duplicate_schedule.present?
        errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
      end
    end
    
    # 重複スケジュール登録拒否
    # DBに保存されている時間はUTCのため、文字列に変換した上で比較
    def except_duplicate_schedule_for_update
      designated_schedules = Schedule.where.not(id: self.id).where(member_code_id: self.member_code_id, scheduled_date: self.scheduled_date)
      if designated_schedules.present?
        designated_schedules.each do |schedule|
          start_time = schedule.scheduled_start_time.to_s(:time)
          end_time = schedule.scheduled_end_time.to_s(:time)
          params_start_time = self.scheduled_start_time.to_s(:time)
          params_end_time = self.scheduled_end_time.to_s(:time)
          if end_time > params_start_time && params_end_time > start_time
            errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
          end
        end
      end
    end
    
    #-----------------------------------------------------
      # CALLBACK_METHOD
    #-----------------------------------------------------
    
    def member_name_update
      unless self.status == "not_set"
        member_code = MemberCode.find(self.member_code_id)
        self.member_name = member_code.member_name_from_member_code
      end
    end
    
    def create_editor
      unless self.status == "not_set" 
        self.create_sales_status_editor(member_code_id: login_user.member_code.id)
      end
    end
    
    def update_editor
       self.sales_status_editor.update(member_code_id: login_user.member_code.id)
    end

end
