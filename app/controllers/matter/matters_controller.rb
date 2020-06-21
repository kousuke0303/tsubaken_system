class Matter::MattersController < ApplicationController
  before_action :matter_index_authenticate!, only: :index
  before_action :matter_show_authenticate!, only: :show
  before_action :matter_edit_authenticate!, only: [:edit, :update, :destroy]
  
  def index
    @progress_matters = @matters.where.not(status: "finish")
    @finished_matters = @matters.where(status: "finish")
  end
  
  def new
    @matter = Matter.new
    @client = @matter.clients.build
  end
  
  def create
    @matter = Matter.new(matter_params)
    if @matter.save
      @matter.update(matter_uid: Faker::Number.hexadecimal(digits: 10))
      @matter.matter_managers.create(manager_id: dependent_manager.id)
      flash[:success] = "受託案件を新規登録しました"
      redirect_to matter_matters_url(dependent_manager)
    end
  end
  
  def show
  end
  
  def edit
    @matter = current_matter
  end
  
  def title_update
    if current_matter.update_attributes!(matter_params)
      flash[:success] = "#{current_matter.title}を編集しました"
      redirect_to matter_matter_url(dependent_manager, current_matter)
    end
  end
  
  def client_update
    if current_matter.update_attributes!(matter_params)
      flash.now[:success] = "#{current_matter.title}を編集しました"
      respond_to do |format|
        format.js
      end
    end
  end
  
  def person_in_charge_update
    if current_matter.update(matter_submanager_params)
      flash[:success] = "担当者の登録をしました"
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    @matter = dependent_manager.matters.find(params[:id])
    @matter.destroy
    flash[:success] = "#{@matter.title}を削除しました"
    redirect_to matter_matters_url(dependent_manager)
  end
  
  def selected_user
    @user = User.find(params[:select_user_id])
    respond_to do |format|
      format.js
    end
  end
  
  private
    def matter_params
      params.require(:matter).permit(:title, :actual_spot, :scheduled_start_at, :scheduled_finish_at,
                                    clients_attributes: [:name, :phone, :fax, :email, :id])
    end
    
    def matter_submanager_params
      params.require(:matter).permit(submanager_ids: [], staff_ids: [])
    end
end
