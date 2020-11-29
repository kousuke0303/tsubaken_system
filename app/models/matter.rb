class Matter < ApplicationRecord
  belongs_to :client
  has_many :matter_managers, dependent: :destroy
  has_many :managers, through: :matter_managers
  has_many :matter_staffs, dependent: :destroy
  has_many :staffs, through: :matter_staffs
  has_many :tasks, dependent: :destroy
<<<<<<< HEAD
  has_many :messages
=======
  has_many :images, dependent: :destroy
>>>>>>> 1a46f858ecbd20721461da07de7e63f9eb25b4fb
  has_many :supplier_matters, dependent: :destroy
  has_many :suppliers, through: :supplier_matters
  accepts_nested_attributes_for :matter_managers, allow_destroy: true
  accepts_nested_attributes_for :matter_staffs, allow_destroy: true
  accepts_nested_attributes_for :supplier_matters, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :title, presence: true, length: { maximum: 30 }

  enum status: {not_started: 0,progress: 1, completed: 2}
  
  before_create :identify

  private
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
end
