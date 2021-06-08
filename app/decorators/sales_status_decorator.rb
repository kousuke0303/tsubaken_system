# frozen_string_literal: true

module SalesStatusDecorator
  
  def update_at_disp
    self.update_at.strftime('%y年%-m月%-d日')
  end
end
