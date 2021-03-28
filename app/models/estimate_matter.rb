class EstimateMatter < ApplicationRecord
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

  before_create :identify
  after_commit :create_sales_status, on: :create

  scope :get_id_by_name, ->(name) { where(client_id: (Client.joins(:estimate_matters).get_by_name "#{ name }").ids) }
  scope :get_by_created_at, ->(year, month) { where("created_at LIKE ?", "#{ year + "-" + format('%02d', month) }%") }

  # 営業履歴と左外部結合
  scope :with_sales_statuses, -> {
    left_joins(:sales_statuses).select(
      "estimate_matters.*",
      "sales_statuses.status AS status",
      "sales_statuses.estimate_matter_id AS estimate_matter_id",
      "sales_statuses.created_at AS sales_status_created_at"
    )
  }
  
  # 進行中
  scope :for_progress, -> {
    joins(:sales_statuses).where.not(sales_statuses: { status: 14})
  }
  
  private
  
  # ----------------------------------------------
    # CALLBACK METHOD
  # ----------------------------------------------
    
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
    
    def create_sales_status
      unless self.sales_statuses.present?
        self.sales_statuses.create!(status: "not_set", scheduled_date: Date.current)
      end
    end
end
