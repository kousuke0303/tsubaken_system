class Staff::MattersController < ApplicationController
  before_action :authenticate_staff!
  before_action :not_current_staff_return_login!
  
  def index
    @progress_matters = current_staff.matters.where.not(status: "finish")
    @finished_matters = current_staff.matters.where(status: "finish")
  end
  
  def show
    matter_task_type
  end
  
  def move_task
    task = Task.find(remove_str(params[:task]))
    task.update(status: params[:status], row_order: roworder_params)
    matter_task_type
    respond_to do |format|
      format.js
    end
  end
  
  private
    # 文字列から数字のみ取り出す
    def remove_str(str)
      str.gsub(/[^\d]/, "").to_i
    end
    
    def roworder_params
      (params[:item_index].to_i * 100 ) - 1
    end
  
end
