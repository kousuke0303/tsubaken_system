class CreateReportCovers < ActiveRecord::Migration[5.2]
  def change
    create_table :report_covers do |t|
      t.string :title
      t.string :matter_id
      t.string :publisher_id
      t.integer :img_1_id
      t.integer :img_2_id
      t.integer :img_3_id
      t.integer :img_4_id
      t.date :created_on

      t.timestamps
    end
    add_index  :report_covers, :matter_id    
    add_index  :report_covers, :publisher_id
  end
end
