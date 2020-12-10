class AddColumnParentIdToConstruction < ActiveRecord::Migration[5.2]
  def change
    add_reference :constructions, :parent, index: true, default: nil
    add_foreign_key :constructions, :constructions, column: :parent_id
  end
end
