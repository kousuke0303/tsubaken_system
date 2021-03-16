class Employees::Matters::AdoptedEstimateDetailsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter_by_matter_id

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def set_adopted_estimate_detail
      @adopted_estimate_detail = AdoptedEstimateDetail.find(params[:id])
    end

    def set_adopted_estimate_of_adopted_estimate_detail
      @estimate = @estimate_detail.estimate
    end
    
    def object_params
      params.require(:adopted_estimate_detail).permit(:name, :service_life, :price, :amount, :note)
    end
end
