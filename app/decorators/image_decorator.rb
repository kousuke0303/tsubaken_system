# frozen_string_literal: true

module ImageDecorator
  
  def report_cover_disp
    if self.report_cover
      content_tag(:i, "", class: "fas fa-check fa-2x")
    end
  end
  
  def report_disp
    if self.report
      content_tag(:i, "", class: "fas fa-check fa-2x")
    end
  end
end
