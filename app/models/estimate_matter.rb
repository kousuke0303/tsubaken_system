class EstimateMatter < ApplicationRecord
  belongs_to :client
  has_one :matter

  validates :title, presence: true, length: { maximum: 30 }

  enum status: { other: 0, appointment: 1, inspection: 2, calculation: 3, immediately: 4, contract: 5, }

  before_create :identify

  private
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
end
