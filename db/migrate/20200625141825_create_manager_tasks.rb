class CreateManagerTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :manager_tasks do |t|
      t.references :manager, index: true, foreign_key: true
      t.references :task, index: true, foreign_key: true
      t.timestamps
    end
  end
end
