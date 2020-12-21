class CreateCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :certificates do |t|
      t.string :title,           null: false
      t.string :content
      t.boolean :default,        default: false
      t.integer :image_id
      t.integer :message_id
      t.string :estimate_matter_id

      t.timestamps
    end
    add_foreign_key :certificates, :estimate_matters
    add_index  :certificates, :estimate_matter_id
  end
end
