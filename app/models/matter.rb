class Matter < ApplicationRecord
  belongs_to :estimate_matter
  has_many :matter_staffs, dependent: :destroy
  has_many :staffs, through: :matter_staffs
  has_many :matter_external_staffs, dependent: :destroy
  has_many :external_staffs, through: :matter_external_staffs
  has_many :tasks, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :supplier_matters, dependent: :destroy
  has_many :suppliers, through: :supplier_matters
  accepts_nested_attributes_for :matter_staffs, allow_destroy: true
  accepts_nested_attributes_for :supplier_matters, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }

  enum status: { not_started: 0, progress: 1, completed: 2 }
  
  before_create :identify

  private
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
end
