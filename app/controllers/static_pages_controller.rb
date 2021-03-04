class StaticPagesController < ApplicationController
  before_action :non_approval_layout
  before_action :reject_signed_in
  
  def top
  end

  def login
  end
  
  private
    def reject_signed_in
      if admin_signed_in?
        redirect_to admins_top_path
      elsif manager_signed_in?
        redirect_to managers_top_path
      elsif staff_signed_in?
        redirect_to staffs_top_path
      elsif external_staff_signed_in?
        redirect_to external_staffs_top_path
      elsif client_signed_in?
        redirect_to clients_top_path
      end
    end
end
