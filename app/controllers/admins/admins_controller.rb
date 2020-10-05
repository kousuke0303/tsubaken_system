class Admins::AdminsController < ApplicationController
  def top
  end

  def show
    @admin = current_admin
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    if @admin.update_attributes(admin_params)
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to admin_top_url
    else
      render :edit
    end
  end

  private
    def admin_params
      params.require(:admin).permit(:name, :password, :password_confirmation)
    end
end
