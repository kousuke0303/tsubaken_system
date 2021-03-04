class CreateCategoryMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :category_materials do |t|
      t.references :category, foreign_key: true
      t.references :material, foreign_key: true
      t.timestamps
    end
  end
end
