class RemoveStaffIdFromSalesStatuses < ActiveRecord::Migration[5.2]
  def change
    remove_reference :sales_statuses, :staff, index: true
    remove_reference :sales_statuses, :external_staff, index: true
  end
end
