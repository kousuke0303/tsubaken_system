class User::MattersController < ApplicationController
  before_action :authenticate_user!
  before_action :not_current_user_return_login!
  
  def matter_connect
    # 連結コードが正しいか
    if matters = Matter.where(connected_id: params[:connected_id])
      # 既に連結済みか否か
      if current_user.matters.where(connected_id: params[:connected_id]).exists?
        flash[:alert] = "既に連結済みです"
        redirect_to top_user_url(current_user)
      else
        # matter.rb/instance_method
        matters.each do |matter|
          matter.connected_matter(current_user)
        end
        flash[:success] = "依頼案件と連結しました"
        redirect_to top_user_url(current_user)
      end
    else
      flash[:alert] = "正しい連結コードを入力してください"
      redirect_to top_user_url(current_user)
    end
  end
  
  def show
    @companies = User.requested_of_company(current_user, current_matter)
    connected_id = current_matter.connected_id
    @requesting_matters = current_user.matters.where(connected_id: connected_id)
  end
  
end