class Matter::MattersController < ApplicationController
  
  def index
  end
  
  def new
    @matter = Matter.new
    @client = @matter.clients.build
  end
  
  def create
    @matter = Matter.new(matter_params)
    if @matter.save
      flash[:notice] = "受託案件を新規登録しました"
      redirect_to matter_matters_url(current_manager)
    end
  end
  
  private
    def matter_params
      params.require(:matter).permit(:id, :title, :actual_spot, :scheduled_start_at, :scheduled_finish_at,
                                    clients_attributes: [:name, :phone])
    end  
end
