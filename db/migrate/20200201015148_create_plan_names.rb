class CreatePlanNames < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_names do |t|
      t.string :name,            null: false, unique: true
      t.integer :position
      t.references :label_color, foreign_key: true

      t.timestamps
    end
  end
end
