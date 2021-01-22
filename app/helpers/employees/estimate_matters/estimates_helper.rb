module Employees::EstimateMatters::EstimatesHelper
  
  def estimate_type(number)
    type = ["A", "B", "C", "D", "E", "F", "G", "H"]
    return type[number]
  end
end
