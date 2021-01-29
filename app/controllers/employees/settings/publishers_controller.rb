class Employees::Settings::PublishersController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_publisher, only: [:edit, :update, :destroy]
  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(publisher_params)
    if @publisher.save
      flash[:success] = "プラン名を作成しました。"
      redirect_to employees_settings_publishers_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @publisher.update(publisher_params)
      flash[:success] = "プラン名を更新しました。"
      redirect_to employees_settings_publishers_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @publishers = Publisher.all
  end

  def destroy
    @publisher.destroy ? flash[:success] = "プラン名を削除しました。" : flash[:alert] = "発行元を削除できませんでした。"
    redirect_to employees_settings_publishers_url
  end

  private
    def set_publisher_params
      params.require(:set_publisher).permit(:name, :postal_code, :prefecture_code, :address_city, :address_street)
    end

    def set_set_publisher
      @set_publisher = Publisher.find(params[:id])
    end
end
