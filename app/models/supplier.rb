class Supplier < ApplicationRecord
  before_save { self.mail = mail.downcase }
  before_save { self.phone = phone.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') }
  before_save { self.fax = fax.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') }
  validates :mail, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }
  
  # scope #################################################
  scope :for_order_count, -> { order(count: "DESC") } 
end
