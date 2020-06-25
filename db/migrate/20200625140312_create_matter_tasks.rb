class CreateMatterTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_tasks do |t|
      t.references :matter, index: true, foreign_key: true
      t.references :task, index: true, foreign_key: true
      t.timestamps
    end
  end
end
