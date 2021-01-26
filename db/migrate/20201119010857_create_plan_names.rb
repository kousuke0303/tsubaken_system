class CreatePlanNames < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_names do |t|
      t.string :name,            null: false
      t.integer :position
      t.integer :label_color,          null: false, default: 0
      

      t.timestamps
    end
  end
end
