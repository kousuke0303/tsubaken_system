class Supplier < ApplicationRecord
  has_many :supplier_matters, dependent: :destroy
  has_many :matters, through: :supplier_matters

  before_save { self.email = email.downcase }
  before_save { self.phone_1 = phone_1.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') }
  before_save { self.phone_2 = phone_2.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') }
  before_save { self.fax = fax.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') }
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true

end
