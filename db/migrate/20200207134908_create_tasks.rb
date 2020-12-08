class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title,         null: false, default: ""
      t.integer :status
      t.integer :before_status
      t.datetime :moved_on
      t.integer :sort_order
      t.string :content
      t.integer :default_task_id
      t.integer :default_task_id_count
      t.string :default_task_request_1
      t.string :default_task_request_2
      t.boolean :notification, default: false
      t.string :estimate_matter_id
      t.string :matter_id
      t.references :staff,            foreign_key: true
      t.references :external_staff,   foreign_key: true

      t.timestamps
    end
    add_index  :tasks, :matter_id
    add_index  :tasks, :estimate_matter_id
    add_foreign_key :tasks, :matters
    add_foreign_key :tasks, :estimate_matters
  end
end
