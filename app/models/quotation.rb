class Quotation < ApplicationRecord
  belongs_to :client
  belongs_to :kind

  validates :title, presence: true, length: { maximum: 30 }
end
