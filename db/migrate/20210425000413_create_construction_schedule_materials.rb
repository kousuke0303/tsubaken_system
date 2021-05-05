class CreateConstructionScheduleMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :construction_schedule_materials do |t|
      t.bigint :construction_schedule_id, null: false
      t.references :material, foreign_key: true
      t.timestamps
    end
    add_index :construction_schedule_materials, [:construction_schedule_id],
                                               name: 'construction_schedule_index'
                                              
    add_foreign_key :construction_schedule_materials, :construction_schedules
  end
end
