module Employees::Matters::ConstructionSchedulesHelper
  
  def memebr_change_disp(construction_schedule)
    if own_staff? || current_supplier_manager.supplier == construction_schedule.supplier
      content_tag(:a, class: 'btn btn-success', href: edit_supplier_managers_construction_schedule_path(construction_schedule), data: {remote: 'true'}) do
        concat '担当者変更'
      end
    end
  end
end
