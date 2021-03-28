class Staffs::MattersController < ApplicationController
  before_action->{can_access_only_of_member(object)}
  before_action :not_current_staff_return_login!
  
  def index
    @matters = Matter.all
    @progress_matters = @matters.longin_user_matters_for_progress(login_user)
    @finished_matters = @matters.login_user_matters_for_finish(login_user)
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
