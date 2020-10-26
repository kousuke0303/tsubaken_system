class Employees::Settings::IndustriesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_industry, only: [:show, :edit, :update, :destroy]

  def index
    @industries = Industry.all
    @industry = Industry.new
  end

  def create
    @industry = Industry.new(industry_params)
    if @industry.save
      flash[:success] = "業種を作成しました"
      redirect_to employees_settings_industries_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @industry.update(industry_params)
      flash[:success] = "業種情報を更新しました"
      redirect_to employees_settings_industries_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @industry.destroy ? flash[:success] = "業種を削除しました" : flash[:alert] = "業種を削除できませんでした"
    redirect_to employees_settings_industries_url
  end

  private
    def set_industry
      @industry = Industry.find(params[:id])
    end

    def industry_params
      params.require(:industry).permit(:name)
    end
end
