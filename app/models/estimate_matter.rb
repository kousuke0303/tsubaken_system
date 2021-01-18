class EstimateMatter < ApplicationRecord
  belongs_to :attract_method, optional: true
  belongs_to :client
  has_one :matter  # 案件と1対1
  # Staffと多対多
  has_many :estimate_matter_staffs, dependent: :destroy
  has_many :staffs, through: :estimate_matter_staffs
  # 外部Staffと多対多
  has_many :estimate_matter_external_staffs, dependent: :destroy
  has_many :external_staffs, through: :estimate_matter_external_staffs
  has_many :tasks, dependent: :destroy  # タスクと1対多
  has_many :estimates, dependent: :destroy  # 見積と1対多
  has_many :images, dependent: :destroy #画像と1対多
  has_many :sales_statuses, dependent: :destroy
  has_many :certificates, -> { order(position: :desc) }, dependent: :destroy #診断書と1対多

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }

  before_create :identify

  scope :get_id_by_name, ->(name) { where(client_id: (Client.joins(:estimate_matters).get_by_name "#{name}").ids) }
  scope :get_by_created_at, ->(year, month) { where("created_at LIKE ?", "#{year + "-" + format('%02d', month)}%") }
  
  private
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
end
