class Employees::TasksController < Employees::EmployeesController
  before_action :authenticate_employee!

  def edit
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    # paramsで送られてきたstatusをenumの数値に変換
    def convert_to_status_num(status)
      case status
      when "default-tasks"
        0
      when "relevant-tasks"
        1
      when "ongoing-tasks"
        2
      when "finished-tasks"
        3
      end
    end
    
    def task_params
      params.require(:task).permit(:title, :content, :staff_id, :external_staff_id)
    end
end
