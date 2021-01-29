class CreatePublishers < ActiveRecord::Migration[5.2]
  def change
    create_table :publishers do |t|
      t.string :name              , null: false
      t.string :postal_code
      t.string :prefecture_code
      t.string :address_city 
      t.string :address_street
      t.string :phone
      t.string :fax

      t.timestamps
    end
  end
end
