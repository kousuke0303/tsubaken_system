module VendorManagers::ConstructionSchedulesHelper
  
  def memebr_change_disp(construction_schedule, retire_external_staff_id = "")
    if own_staff? || current_vendor_manager.vendor == construction_schedule.vendor
      if retire_external_staff_id == "" 
        content_tag(:a, class: 'btn btn-success', href: edit_vendor_managers_construction_schedule_path(construction_schedule), data: {remote: 'true'}) do
          concat '担当者変更'
        end
      else
        content_tag(:a, class: 'btn btn-success', href: edit_vendor_managers_construction_schedule_path(construction_schedule, retire_external_staff_id: retire_external_staff_id), data: {remote: 'true'}) do
          concat '担当者変更'
        end
      end
    end
  end
  
end