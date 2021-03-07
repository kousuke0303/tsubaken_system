class Inquiry < ApplicationRecord
  validates :kind, presence: true

  enum kind: { lost: 0 }
end
