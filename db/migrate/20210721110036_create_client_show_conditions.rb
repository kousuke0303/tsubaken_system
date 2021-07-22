class CreateClientShowConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :client_show_conditions do |t|
      t.boolean :certificate, default: false
      t.boolean :estimate, default: false
      t.boolean :construction_schedule, default: false
      t.boolean :report, default: false
      t.boolean :invoice, default: false
      t.references :client, foreign_key: true
      t.timestamps
    end
  end
end
