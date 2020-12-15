class CreateCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :certificates do |t|
      t.string :title
      t.string :content
      t.boolean :default,        default: false
      t.integer :image_id
      t.integer :message_id

      t.timestamps
    end
  end
end
