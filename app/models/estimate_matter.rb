class EstimateMatter < ApplicationRecord
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
  has_many :messages, dependent: :destroy #チャットルーム内のメッセージと1対多

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }

  enum status: { other: 0, appointment: 1, inspection: 2, calculation: 3, immediately: 4, contract: 5, contemplation_month: 6,
                 contemplation_year: 7, lost: 8, lost_by_other: 9, chasing: 10, waiting_insurance: 11, consideration: 12 }

  before_create :identify

  private
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
end
