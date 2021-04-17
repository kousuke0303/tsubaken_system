class Employees::CurrentSituationsController < Employees::EmployeesController
  before_action :current_situations_display
  # before_action :set_span
  
  def index
    @staffs = Staff.enrolled
    @current_situation_span = Span.new
    reference_date = params[:date] || Date.current
    @current_situation_span.three_month(reference_date)
    @target_est_matters = EstimateMatter.for_span(@current_situation_span.first_day, @current_situation_span.last_day)
                                        .group_by{|list| list.created_at.month} 
    @ganttchart_span = Span.new
    @ganttchart_span.after_two_month(reference_date)
    month_matters(@ganttchart_span.first_day, @ganttchart_span.last_day)
  end
  
  def move_span_for_progress
    @current_situation_span = Span.new
    if params[:span].to_i == 3
      @current_situation_span.three_month(params[:date].to_date)
    else
      @current_situation_span.six_month(params[:date].to_date)
    end
    @target_est_matters = EstimateMatter.for_span(@current_situation_span.first_day, @current_situation_span.last_day)
                                        .group_by{|list| list.created_at.month}
  end
  
  def move_span_for_ganttchart
    @ganttchart_span = Span.new
    month_matters(@ganttchart_span.first_day, @ganttchart_span.last_day)
    @ganttchart_span.after_two_month(params[:date].to_date)
    month_matters(@ganttchart_span.first_day, @ganttchart_span.last_day)
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
    
    def month_matters(first_day, last_day)
      matters = Matter.all
      @target_matters = matters.where(started_on: first_day..last_day)
                               .or(matters.where(finished_on: first_day..last_day))
                               .or(matters.where(scheduled_started_on: first_day..last_day))
                               .or(matters.where(scheduled_finished_on: first_day..last_day))
    end
end
