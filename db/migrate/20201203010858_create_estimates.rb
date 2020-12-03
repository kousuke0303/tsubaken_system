class CreateEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :estimates do |t|
      t.string :title,                 null: false, default: ""
      t.string :estimate_matter_id
      t.timestamps
    end
    add_index  :estimates, :estimate_matter_id
  end
end
