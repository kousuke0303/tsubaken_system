module Employees::Matters::ConstructionSchedulesHelper

  def memebr_change_disp(construction_schedule)
    if own_staff? || current_vendor_manager.vendor == construction_schedule.vendor
      content_tag(:a, class: 'btn btn-success', href: edit_vendor_managers_construction_schedule_path(construction_schedule), data: {remote: 'true'}) do
        concat '担当者変更'
      end
    end
  end
end
