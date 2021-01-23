class AddColumnsToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :sort_number, :integer
  end
end
