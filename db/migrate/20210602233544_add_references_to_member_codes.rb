class AddReferencesToMemberCodes < ActiveRecord::Migration[5.2]
  def change
    add_reference :member_codes, :vendor_manager, foreign_key: true
  end
end
