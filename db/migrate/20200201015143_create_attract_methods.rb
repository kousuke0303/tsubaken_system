class CreateAttractMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :attract_methods do |t|
      t.string :name,             null: false  

      t.timestamps
    end
  end
end
