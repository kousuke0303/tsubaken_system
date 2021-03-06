class Matter < ApplicationRecord

  before_create :identify
  after_commit :staff_external_staff_connection_and_task_set, on: :create

  belongs_to :estimate_matter
  belongs_to :estimate
  belongs_to :publisher, optional: true
  belongs_to :client

  has_one :band_connection, dependent: :destroy

  has_many :matter_member_codes, dependent: :destroy
  has_many :member_codes, through: :matter_member_codes

  has_many :vendor_matters, dependent: :destroy
  has_many :vendors, through: :vendor_matters

  has_one :invoice, dependent: :destroy
  has_many :reports, -> { order(position: :asc) }, dependent: :destroy
  has_one :report_cover, dependent: :destroy

  has_many :tasks, dependent: :destroy
  has_many :construction_schedules, dependent: :destroy
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images
  has_many :messages, dependent: :destroy

  # accepts_nested_attributes_for :vendor_matters, allow_destroy: true
  # accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :scheduled_started_on, presence: true
  validates :scheduled_finished_on, presence: true
  validate :scheduled_finished_on_is_after_started_on
  validate :finished_on_require_started_on
  validate :finished_on_is_after_started_on

  enum status: { not_started: 0, progress: 1, completed: 2 }

  scope :join_estimate_matter, ->{ joins(:estimate_matter) }

  def self.title_from_id(id)
    Matter.find(id).title
  end

  def staffs_in_charge
    Staff.joins(member_code: :matters).where(member_codes: {matters: {id: self.id}})
  end

  def external_staffs
    ExternalStaff.joins(member_code: :matters).where(member_codes: {matters: {id: self.id}})
  end

  def external_staffs_in_charge_for_group_by_vendor
    ExternalStaff.joins(member_code: :matters).where(member_codes: {matters: {id: self.id}})
                 .group_by{|external_staff| external_staff.vendor_id }
  end

  def member
    member_arrey = []
    MemberCode.new
    all_member_code = MemberCode.all_member_code_of_avaliable
    all_member_code.joins(:admin).select('member_codes.*, admins.name AS admin_name').each do |member_code|
      date = []
      date.push(member_code.admin_name)
      date.push(member_code.id)
      member_arrey.push(date)
    end
    all_member_code.joins(:manager).select('member_codes.*, managers.name AS manager_name').each do |member_code|
      date = []
      date.push(member_code.manager_name)
      date.push(member_code.id)
      member_arrey.push(date)
    end
    all_member_code.joins(:matters).where(matters: {id: self.id}).each do |member_code|
      date = []
      date.push(member_code.member_name_from_member_code)
      date.push(member_code.id)
      member_arrey.push(date)
    end
    return member_arrey
  end

  # 自社スタッフの担当者
  def member_ids_in_charge
    member_ids = []
    # admin/managerのid追加
    admin_code_id = Admin.first.member_code.id
    manager_ids = Manager.all.avaliable.ids
    manager_code_ids = MemberCode.joins(:manager).where(managers: {id: manager_ids}).ids
    member_ids.push(admin_code_id)
    member_ids.push(manager_code_ids)
    # 担当staffのid追加
    staff_ids = self.member_codes.joins(:staff).where(staffs: { avaliable: true}).ids
    member_ids.push(staff_ids)
    return member_ids.flatten
  end

  def change_invoice(estimate_id)
    ActiveRecord::Base.transaction do
      @matter.update!(estimate_id: estimate_id)
      self.invoice.destroy!
      invoice = self.build_invoice(total_price: self.estimate.total_price,
                                   discount: self.estimate.discount,
                                   plan_name_id: self.estimate.plan_name_id)

      invoice.save!
    end
  rescue => e
      Rails.logger.error e.class
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # bugsnag導入後
      # Bugsnag.notifiy e
  end

  private

  #----------------------------------------------
    #CALLBACK_METGOD
  #---------------------------------------------

    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end

    def staff_external_staff_connection_and_task_set
      ActiveRecord::Base.transaction do
        Task.auto_set_lists_for_matter.each_with_index do |task, index|
          self.tasks.create!(title: task.title, status: 1, sort_order: index, default_task_id: task.id)
        end
        self.estimate_matter.member_codes.each do |member_code|
          self.matter_member_codes.create!(member_code_id: member_code.id)
        end
        invoice = self.build_invoice(total_price: self.estimate.total_price,
                                     discount: self.estimate.discount,
                                     plan_name_id: self.estimate.plan_name_id)
        invoice.save!
      end
    rescue => e
      Rails.logger.error e.class
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # bugsnag導入後
      # Bugsnag.notifiy e
    end


  #----------------------------------------------
    #VALIDATE_METHOD
  #---------------------------------------------

    def scheduled_finished_on_is_after_started_on
      if scheduled_finished_on.present? && scheduled_started_on.present? && scheduled_started_on >= scheduled_finished_on
        errors.add(:scheduled_finished_on, "は着工予定日以降を入力してください")
      end
    end

    # finished_onはstarted_on必須
    def finished_on_require_started_on
      errors.add(:started_on, "を入力してください") if started_on.blank? && finished_on.present?
    end

    # finished_onはstarted_on以降
    def finished_on_is_after_started_on
      if started_on.present? && finished_on.present?
        errors.add(:finished_on, "は着工日より後の日付で入力してください") if finished_on <= started_on
      end
    end
end
