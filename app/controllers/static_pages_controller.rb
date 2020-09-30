class StaticPagesController < ApplicationController
  before_action :non_approval_layout
  before_action :reject_signed_in
  
  def login_index
  end
  
  def test_preview
    @type = test_preview
  end
  
  private
  def reject_signed_in
    if admin_signed_in?
      redirect_to top_admin_path(current_admin)
    elsif manager_signed_in?
      redirect_to top_manager_path(current_manager)
    elsif staff_signed_in?
      redirect_to top_staff_path(current_staff)
    elsif user_signed_in?
      redirect_to top_user_path(current_user)
    end
  end 
end
