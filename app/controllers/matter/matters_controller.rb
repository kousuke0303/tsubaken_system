class Matter::MattersController < ApplicationController
  
  def index
    @progress_matters = current_manager.matters.where.not(status: "finish")
    @finished_matters = current_manager.matters.where(status: "finish")
  end
  
  def new
    @matter = Matter.new
    @client = @matter.clients.build
  end
  
  def create
    @matter = Matter.new(matter_params)
    if @matter.save
      @matter.update(matter_uid: Faker::Number.hexadecimal(digits: 10))
      @matter.matter_managers.create(manager_id: current_manager.id)
      flash[:success] = "受託案件を新規登録しました"
      redirect_to matter_matters_url(current_manager)
    end
  end
  
  def show
  end
  
  def edit
    @matter = current_matter
  end
  
  def update
    if current_matter.update_attributes!(matter_params)
      flash[:success] = "#{current_matter.title}を編集しました"
      redirect_to matter_matter_url(current_manager, current_matter)
    end
  end
  
  def destroy
    @manager = current_manager
    @matter = current_manager.matters.find(params[:id])
    @matter.destroy
    redirect_to matter_matters_url(current_manager)
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
                                    clients_attributes: [:name, :phone, :email, :id])
    end
end
