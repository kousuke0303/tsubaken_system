class StaticPagesController < ApplicationController
  before_action :non_approval_layout
  before_action :top_redirect
  
  def login_index
  end
  
  def test_preview
    @type = test_preview
  end
  
  private
  def top_redirect
    if user_signed_in?
      redirect_to top_user_path(current_user)
    end
  end 
end
