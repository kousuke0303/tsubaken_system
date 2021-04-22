class EstimateMatter < ApplicationRecord
  
  before_create :identify
  after_commit :create_sales_status_task_set, on: :create
  
  belongs_to :attract_method, optional: true
  belongs_to :client
  belongs_to :publisher, optional: true
  
  has_one :matter, dependent: :destroy # 案件と1対1
  has_one :band_connection, dependent: :destroy
  has_one :cover
  
  has_many :estimate_matter_member_codes, dependent: :destroy
  has_many :member_codes, through: :estimate_matter_member_codes
  
  has_many :tasks, dependent: :destroy  # タスクと1対多
  has_many :estimates, -> { order(position: :asc) }, dependent: :destroy # 見積と1対多
  has_many :images, dependent: :destroy #画像と1対多
  accepts_nested_attributes_for :images
  has_many :sales_statuses, dependent: :destroy
  has_many :certificates, -> { order(position: :asc) }, dependent: :destroy #診断書と1対多

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }

  scope :get_id_by_name, ->(name) { where(client_id: (Client.joins(:estimate_matters).get_by_name "#{ name }").ids) }
  scope :get_by_created_at, ->(year, month) { where("created_at LIKE ?", "#{ year + "-" + format('%02d', month) }%") }
  scope :for_span, ->(first_day, last_day){ where(created_at: first_day..last_day).order(:created_at)}

  # 営業履歴と左外部結合
  scope :with_sales_statuses, -> {
    left_joins(:sales_statuses).select(
      "estimate_matters.*",
      "sales_statuses.status AS status",
      "sales_statuses.estimate_matter_id AS estimate_matter_id",
      "sales_statuses.created_at AS sales_status_created_at"
    )
  }
  
  # 着工済みの営業案件
  scope :for_start_of_constraction, -> {
    joins(:sales_statuses).where(sales_statuses: {status: 14})
  }
  
  # 進行中
  scope :for_progress, -> {
    joins(:sales_statuses).where.not(sales_statuses: { status: 14})
  }
  
  def staffs_in_charge
    Staff.joins(member_code: :estimate_matters).where(member_codes: {estimate_matters: {id: self.id}})
  end
  
  def external_staffs_in_charge_for_group_by_supplier
    ExternalStaff.joins(member_code: :estimate_matters).where(member_codes: {estimate_matters: {id: self.id}})
                 .group_by{|external_staff| external_staff.supplier_id }
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
    all_member_code.joins(:estimate_matters).where(estimate_matters: {id: self.id}).each do |member_code|
      date = [] 
      date.push(member_code.member_name_from_member_code)
      date.push(member_code.id)
      member_arrey.push(date)
    end
    return member_arrey
  end
  
  # 見積依頼日
  def calculation_day
    sales_status_for_calculation = self.sales_statuses.find_by(status: 4)
    sales_status_for_calculation.created_at.strftime("%Y年%-m月%-d日")
  end
  
  private
  
  # ----------------------------------------------
    # CALLBACK METHOD
  # ----------------------------------------------
    
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
    
    def create_sales_status_task_set
      unless self.sales_statuses.present?
        self.sales_statuses.create!(status: "not_set", scheduled_date: Date.current)
      end
      Task.auto_set_lists_for_estimate_matter.each_with_index do |task, index|
        self.tasks.create!(title: task.title, status: 1, sort_order: index, default_task_id: task.id) 
      end
    end
end
