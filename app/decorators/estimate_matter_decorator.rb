# frozen_string_literal: true

module EstimateMatterDecorator
  
  # 見積依頼日
  def calculation_day
    if self.sales_statuses.find_by(status: 4).present?
      sales_status_for_calculation = self.sales_statuses.find_by(status: 4)
      sales_status_for_calculation.created_at.strftime("%Y年%-m月%-d日")
    end
  end
  
end
