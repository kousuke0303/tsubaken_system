class Employees::Settings::PlanNamesController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_plan_name, only: [:edit, :update, :destroy]

  def new
    @plan_name = PlanName.new
  end

  def create
    @plan_name = PlanName.new(plan_name_params)
    if @plan_name.save
      flash[:success] = "プラン名を作成しました。"
      redirect_to employees_settings_plan_names_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @plan_name.update(plan_name_params)
      flash[:success] = "プラン名を更新しました。"
      redirect_to employees_settings_plan_names_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @plan_names = PlanName.order(position: :asc)
  end

  def destroy
    @plan_name.destroy ? flash[:success] = "プラン名を削除しました。" : flash[:alert] = "プラン名を削除できませんでした。"
    redirect_to employees_settings_plan_names_url
  end

  def sort
    from = params[:from].to_i + 1
    plan_name = PlanName.find_by(position: from)
    plan_name.insert_at(params[:to].to_i + 1)
    @plan_names = PlanName.order(position: :asc)
    respond_to do |format|
      format.js
    end
  end

  private
    def plan_name_params
      params.require(:plan_name).permit(:name, :color)
    end

    def set_plan_name
      @plan_name = PlanName.find(params[:id])
    end
end
