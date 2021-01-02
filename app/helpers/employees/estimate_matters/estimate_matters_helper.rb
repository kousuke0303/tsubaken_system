module Employees::EstimateMatters::EstimateMattersHelper
  
  def member_name(estimate_matter)
    members = []
    if estimate_matter.staffs.present?
      estimate_matter.staffs.each do |estimate_matter_staff|
        members << estimate_matter_staff.name
      end
    end
    if estimate_matter.external_staffs.present?
      estimate_matter.external_staffs.each do |estimate_matter_external_staff|
        members << estimate_matter_external_staff.name
      end
    end
    return members.join('　')
  end
end
