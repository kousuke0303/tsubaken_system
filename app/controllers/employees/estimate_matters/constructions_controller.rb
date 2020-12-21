class Employees::EstimateMatters::ConstructionsController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_construction

  def edit
  end

  def update
    if @construction.update(construction_params)
      @response = "success"
      set_estimates_details(@estimate_matter)
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @construction.destroy
    set_estimates_details(@estimate_matter)
    respond_to do |format|
      format.js
    end
  end

  private
    def set_construction
      @construction = Construction.find(params[:id])
    end

    def construction_params
      params.require(:construction).permit(:name, :price, :amount)
    end
end
