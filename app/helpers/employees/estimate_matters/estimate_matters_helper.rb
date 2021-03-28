module Employees::EstimateMatters::EstimateMattersHelper
  
  def person_in_charge_for(members_code_arrey)
    return members_code_arrey.join('　')
  end
end
