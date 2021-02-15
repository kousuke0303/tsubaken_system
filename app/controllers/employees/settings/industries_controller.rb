class Employees::Settings::IndustriesController < ApplicationController
  before_action :set_industry, only: [:edit, :update, :destroy]

  def new
    @industry = Industry.new
  end

  def index
    @industries = Industry.order(position: :asc)
  end

  def create
    @industry = Industry.new(industry_params)
    if @industry.save
      flash[:success] = "業種を作成しました。"
      redirect_to employees_settings_industries_url
    end
  end

  def edit
  end

  def update
    if @industry.update(industry_params)
      flash[:success] = "業種情報を更新しました。"
      redirect_to employees_settings_industries_url
    end
  end

  def destroy
    @industry.destroy ? flash[:success] = "業種を削除しました。" : flash[:alert] = "業種を削除できませんでした。"
    redirect_to employees_settings_industries_url
  end

  def sort
    from = params[:from].to_i + 1
    industry = Industry.find_by(position: from)
    industry.insert_at(params[:to].to_i + 1)
    @industries = Industry.order(position: :asc)
  end

  private
    def set_industry
      @industry = Industry.find(params[:id])
    end

    def industry_params
      params.require(:industry).permit(:name)
    end
end
