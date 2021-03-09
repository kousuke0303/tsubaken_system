class Inquiry < ApplicationRecord
  before_save { self.email = email.downcase if email.present? }
  before_save { self.reply_email = reply_email.downcase if reply_email.present? }

  validates :kind, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :reply_email, presence: true, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }

  enum kind: { lost: 0 }
end
