class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.text :content
      t.string :author
      t.string :default_file_path
      t.date :shooted_on
      t.integer :admin_id
      t.integer :manager_id
      t.integer :staff_id
      t.integer :external_staff_id
      t.string :estimate_matter_id
      t.string :matter_id

      t.timestamps
    end
    add_foreign_key :images, :estimate_matters
    add_foreign_key :images, :matters
    add_index  :images, :estimate_matter_id
    add_index  :images, :matter_id
  end
end
