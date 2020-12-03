class CreateEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :estimates do |t|
      t.string :title,                 null: false, default: ""
      t.string :estimate_matter_id
      t.references :kind, foreign_key: true
      t.timestamps
    end
    add_index  :estimates, :estimate_matter_id
  end
end
