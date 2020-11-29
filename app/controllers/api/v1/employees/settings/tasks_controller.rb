class Api::V1::Employees::Settings::TasksController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_task, only: [:update, :destroy]

  def create
    sort_order = Task.are_default.length
    @default_task = Task.new(default_task_params.merge(status: 0, sort_order: sort_order))
    if @default_task.save
      render json: @default_task, serializer: TaskSerializer
    else
      render json: { status: "false", message: @default_task.errors.full_messages }
    end
  end

  def update
    if @default_task.update(default_task_params)
      render json: @default_task, serializer: TaskSerializer
    else
      render json: { status: "false", message: @default_task.errors.full_messages }
    end
  end

  def destroy
    if @default_task.destroy
      Task.reload_sort_order(Task.are_default)
      render json: @default_task, serializer: TaskSerializer
    else
      render json: { status: "false", message: @default_task.errors.full_messages }
    end
  end

  private
    def default_task_params
      params.permit(:title, :content)
    end

    def set_task
      @default_task= Task.find(params[:id])
    end
end
