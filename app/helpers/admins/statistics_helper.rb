module Admins::StatisticsHelper
  
  # 成約率
  def contract_rate(contract, number)
    if number == 0
      return 0
    else
      return sprintf("%.f", contract/number.to_f*100.to_f)
    end
  end
end
