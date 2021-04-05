class Employees::EstimateMatters::CurrentSituationsController < Employees::EmployeesController
  before_action :current_situations_display
  before_action :set_span
  
  def index
    @staffs = Staff.enrolled
    reference_date = params[:date] || Date.current
    @span.three_month(reference_date)
    @target_est_matters = EstimateMatter.for_span(@span.first_day, @span.last_day)
                                        .group_by{|list| list.created_at.month} 
  end
  
  def move_span
    if params[:span].to_i == 3
      @span.three_month(params[:date].to_date)
    else
      @span.six_month(params[:date].to_date)
    end
    @target_est_matters = EstimateMatter.for_span(@span.first_day, @span.last_day)
                                        .group_by{|list| list.created_at.month}
  end
  
  def change_span
    if params[:span].to_i == 3
      @span.three_month(params[:reference_date].to_date)
    else
      @span.six_month(params[:reference_date].to_date)
    end
    @target_est_matters = EstimateMatter.for_span(@span.first_day, @span.last_day)
                                        .group_by{|list| list.created_at.month}
  end
  
  private
    def set_span
      @span= Span.new
    end

end
