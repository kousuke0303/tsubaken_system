class SalesStatusEditor < ApplicationRecord
  belongs_to :sales_status
  
  before_save :member_name_update
  
  validate :require_editor
  
  def require_editor
    errors.add(:base, "実施者を選択してください") if authority.nil? || member_id.nil?
  end
  
  #-----------------------------------------------------
    # CALLBACK_METHOD
  #-----------------------------------------------------
  
  def member_name_update
    unless self.sales_status.status == 0
      if self.authority == "admin"
        member_name = Admin.find(self.member_id).name
      elsif self.authority == "manager"
        member_name = Manager.find(self.member_id).name
      elsif self.authority == "staff"
        member_name = Staff.find(self.member_id).name
      elsif self.authority == "external_staff"
        member_name = ExternalStaff.find(self.member_id).name
      else
        member_name = nil
      end
      self.member_name =  member_name
    end
  end
end
