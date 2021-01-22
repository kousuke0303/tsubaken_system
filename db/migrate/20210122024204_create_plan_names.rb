class CreatePlanNames < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_names do |t|
      t.string :name,            null: false
      t.integer :position

      t.timestamps
    end
  end
end
