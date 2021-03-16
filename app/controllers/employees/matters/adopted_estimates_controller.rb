class Employees::Matters::AdoptedEstimatesController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter_by_matter_id
  before_action :set_adopted_estimate

  def edit
    @categories = Category.order(position: :asc)
    @plan_names = PlanName.order(position: :asc)
    @color_code = @adopted_estimate.plan_name.label_color.color_code
    @default_color = LabelColor.first.color_code
    # カテゴリ登録がすでにある場合
    if @adopted_estimate.adopted_estimate_details.present?
      @adopted_estimate_details = @adopted_estimate.adopted_estimate_details.order(:sort_number).group(:category_id)
      @type = "category_presence"
    # カテゴリがない場合
    else
      @type = "no_category"
    end
  end

  def update
  end

  def destroy
  end

  private
    def set_adopted_estimate
      @adopted_estimate = AdoptedEstimate.find(params[:id])
    end
end
