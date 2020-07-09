class Supplier < ApplicationRecord
  before_save { self.mail = mail.downcase }
  before_save { self.phone = phone.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') }
  before_save { self.fax = fax.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') }
  
  # validation ############################################
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :mail, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  
  # アソシエーション ######################################
  belongs_to :manager
  
  # scope #################################################
  scope :for_order_count, -> { order(count: "DESC") } 
end
