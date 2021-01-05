class SalesStatusMember < ApplicationRecord
  belongs_to :sales_status
  
  validate :require_member
  
  def require_member
    errors.add(:base, "担当者を選択してください") if authority.nil? || member_id.nil?
  end
end
