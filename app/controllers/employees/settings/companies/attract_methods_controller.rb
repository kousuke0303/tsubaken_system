class Employees::Settings::Companies::AttractMethodsController < Employees::Settings::CompaniesController
  before_action :set_attract_method, only: [:edit, :update, :destroy]

  def create
    @attract_method = AttractMethod.new(attract_method_params)
    @attract_method.save ? @responce = "success" : @responce = "failure"
    set_attract_methods
  end

  def edit
  end

  def update
    @attract_method.update(attract_method_params) ? @responce = "success" : @responce = "failure"    
    set_attract_methods
  end

  def destroy
    @attract_method.destroy ? @responce = "success" : @responce = "failure"    
    set_attract_methods
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

