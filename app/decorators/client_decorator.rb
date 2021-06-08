# frozen_string_literal: true

module ClientDecorator
  
  def avaliable_disp
    if self.avaliable
      content_tag(:span, "ログイン可能", class: "badge badge-primary")
    else
      content_tag(:span, "ログイン未許可", class: "badge badge-dark")
    end
  end
  
  def last_update_for_estimate_matter_or_matter
    if self.matters.present?
      self.matters.order(updated_at: "DESC").first.updated_at.strftime("%y年%-m月%-d日")
    elsif self.estimate_matters.present?
      self.estimate_matters.order(updated_at: "DESC").first.updated_at.strftime("%y年%-m月%-d日")
    else
      content_tag(:p, "案件未登録")
    end
  end
end
