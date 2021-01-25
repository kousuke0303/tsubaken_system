class RemoveEstimateIdFromCategories < ActiveRecord::Migration[5.2]
  def change
    remove_reference :categories, :estimate, index: true
  end
end
