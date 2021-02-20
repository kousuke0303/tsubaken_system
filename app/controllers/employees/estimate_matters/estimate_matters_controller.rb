class Employees::EstimateMatters::EstimateMattersController < Employees::EmployeesController
  before_action :authenticate_employee!
  
  # 見積案件の持つ全見積を定義
  def set_estimates
    @estimates = @estimate_matter.estimates
  end

  # 見積案件の持つ全estimate_detailsを定義(estimatesと結合して)
  def set_estimate_details
    @estimate_details = @estimates.with_estimate_details
  end

  private
    # 見積案件の担当Staff・外部Staffを定義
    def set_person_in_charge(estimate_matter)
      @staffs = estimate_matter.staffs
      @external_staffs = estimate_matter.external_staffs
    end
end
