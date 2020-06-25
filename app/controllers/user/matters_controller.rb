class User::MattersController < ApplicationController
  before_action :authenticate_user!
  
  def matter_connect
    # 連結コードが正しいか
    if matter = Matter.find_by(matter_uid: params[:connencted_id])
      # 既に連結済みか否か
      if current_user.matters.where(id: matter.id).exists?
        flash[:alert] = "既に連結済みです"
        redirect_to top_user_url(current_user)
      else
        # matter.rb/instance_method
        matter.connected_matter(current_user)
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
  end
end