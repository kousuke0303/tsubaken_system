class Employees::Settings::AttractMethodsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_attract_method, only: [:edit, :update, :destroy]

  def new
    @attract_method = AttractMethod.new
  end

  def create
    @attract_method = AttractMethod.new(attract_method_params)
    if @attract_method.save
      flash[:success] = "集客方法を作成しました。"
      redirect_to employees_settings_attract_methods_url
    end
  end

  def edit
  end

  def update
    if @attract_method.update(attract_method_params)
      flash[:success] = "集客方法を更新しました。"
      redirect_to employees_settings_attract_methods_url
    end
  end

  def index
    @attract_methods = AttractMethod.order(position: :asc)
  end

  def destroy
    @attract_method.destroy ? flash[:success] = "集客方法を削除しました。" : flash[:alert] = "集客方法を削除できませんでした。"
    redirect_to employees_settings_attract_methods_url
  end

  def sort
    from = params[:from].to_i + 1
    attract_method = AttractMethod.find_by(position: from)
    attract_method.insert_at(params[:to].to_i + 1)
    @attract_methods = AttractMethod.order(position: :asc)
  end

  private
    def attract_method_params
      params.require(:attract_method).permit(:name)
    end

    def set_attract_method
      @attract_method = AttractMethod.find(params[:id])
    end
end
