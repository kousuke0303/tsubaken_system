class Employees::EstimateMatters::EstimateMattersController < Employees::EmployeesController
  before_action :authenticate_employee!
  
  private

    # 見積案件の担当Staff・外部Staffを定義
    def set_person_in_charge(estimate_matter)
      @staffs = estimate_matter.staffs
      @external_staffs = estimate_matter.external_staffs
    end
end
