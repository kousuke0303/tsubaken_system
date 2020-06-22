class User::MattersController < ApplicationController
  
  def matter_connect
    if @matter = Matter.find_by(matter_uid: params[:connencted_id])
      @matter.matter_users.create(user_id: current_user.id)
      redirect_to top_user_url(current_user)
    else
      flash[:alert] = "正しい連結コードを入力してください"
      redirect_to top_user_url(current_user)
    end
  end
  
  def show
  end
end
