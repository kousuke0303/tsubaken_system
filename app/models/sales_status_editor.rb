class SalesStatusEditor < ApplicationRecord
  belongs_to :sales_status
  
  validate :require_editor
  
  def require_editor
    errors.add(:base, "実施者を選択してください") if authority.nil? || member_id.nil?
  end
end
