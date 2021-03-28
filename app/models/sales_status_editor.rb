class SalesStatusEditor < ApplicationRecord
  belongs_to :sales_status
  belongs_to :member_code, optional: true
  
  before_save :member_name_update
  
  private
  
    #-----------------------------------------------------
      # CALLBACK_METHOD
    #-----------------------------------------------------
    
    def member_name_update
      unless self.sales_status.status == 0
        member_code = MemberCode.find(self.member_code_id)
        if member_code.admin_id.present?
          member_name = member_code.admin.name
        elsif member_code.manager_id.present?
          member_name = member_code.manager.name
        elsif member_code.staff_id.present?
          member_name = member_code.staff.name
        elsif member_code.external_staff.present?
          member_name = member_code.external_staff.name
        end
        self.member_name = member_name
      end
    end
end
