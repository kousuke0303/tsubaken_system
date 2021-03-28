class StaticPagesController < ApplicationController
  before_action :non_approval_layout
  
  def top
  end
  
  def error
    flash[:alert] = "ログインIDが登録されていません"
    redirect_to root_url
  end
    
end
