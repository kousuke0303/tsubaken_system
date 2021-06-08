# frozen_string_literal: true

module SupplierDecorator
  
  def person_in_charge_for_matter(matter_or_estimate_matter)
    if self.external_staffs.present?
      target_external_staffs = self.external_staffs
      if matter_or_estimate_matter.model_name.name == "Matter"
        external_staffs = target_external_staffs.joins(member_code: :matters)
                                                .where(member_codes: {matters: {id: matter_or_estimate_matter.id}})
      end
      if matter_or_estimate_matter.model_name.name == "EstimateMatter"
        external_staffs = target_external_staffs.joins(member_code: :estimate_matters)
                                                .where(member_codes: {estimate_matters: {id: matter_or_estimate_matter.id}})
      end
      if external_staffs.present?
        external_staffs.pluck(:name).join(' ')
      else
        content_tag(:p, "未登録", class: "mg-0")
      end
    else
      return self.supplier_manager.name
    end
  end
  
  def avaliable_disp
    if self.supplier_manager.present? && self.supplier_manager.avaliable
      content_tag(:span, "可能", class: "badge badge-success")
    end
  end
end
