class CreateDefaultTaskRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :default_task_requests do |t|
      t.integer :default_task_request_id
      t.integer :before_status
      t.datetime :moved_on
      t.integer :sort_order
      t.integer :status
      t.string :default_task_request_1
      t.string :default_task_request_2
      t.string :estimate_matter_id
      t.string :matter_id

      t.timestamps
    end
    add_index  :default_task_requests, :matter_id
    add_index  :default_task_requests, :estimate_matter_id
    add_foreign_key :default_task_requests, :matters
    add_foreign_key :default_task_requests, :estimate_matters
  end
end
