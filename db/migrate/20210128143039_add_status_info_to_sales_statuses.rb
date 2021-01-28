class AddStatusInfoToSalesStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :sales_statuses, :scheduled_start_time, :time
    add_column :sales_statuses, :scheduled_end_time, :time
    add_column :sales_statuses, :place, :string
  end
end
