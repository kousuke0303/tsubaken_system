class Employees::Settings::KindsController < ApplicationController
  before_action :set_kind, only: [:edit, :update, :destroy]

  def new
    @kind = Kind.new
  end

  def create
    @kind = Kind.new(kind_params)
    if @kind.save
      flash[:success] = "見積書タイプを作成しました。"
      redirect_to employees_settings_kinds_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @kind.update(kind_params)
      flash[:success] = "見積書タイプを更新しました。"
      redirect_to employees_settings_kinds_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @kinds = Kind.all
  end

  def destroy
    @kind.destroy ? flash[:success] = "見積書タイプを削除しました。" : flash[:alert] = "見積書タイプを削除できませんでした。"
    redirect_to employees_settings_kinds_url
  end

  private
    def kind_params
      params.require(:kind).permit(:name)
    end

    def set_kind
      @kind = Kind.find(params[:id])
    end
end
