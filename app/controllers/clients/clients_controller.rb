class Clients::ClientsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_estimate_matter, except: [:top, :detail]
  before_action :set_matter, only: [:schedule, :report, :invoice]
  before_action :set_condition
  # before_action :preview_display, only: [:invoice]
  
  def top
  end
  
  def certificate
    @cover = @estimate_matter.cover
    @certificates = @estimate_matter.certificates
  end
  
  def estimate
    @estimates = @estimate_matter.estimates.with_plan_names_and_label_colors
    @estimate_details = @estimates.with_estimate_details
    @instructions = @estimate_matter.instructions.order(:position)
  end
  
  def detail
    @estimate = Estimate.find(params[:id])
    @details_hash = @estimate.estimate_details.where(estimate_details: { estimate_id: @estimate.id }).order(:sort_number).group_by{ |detail| detail[:category_id] }
  end
  
  def instruction
    @instructions = @estimate_matter.instructions.order(:position)
  end
  
  def schedule
    @calendar_type = "vendors_schedule"
    if params[:start_date].present?
      object_day = params[:start_date].to_date
    else
      object_day = Date.current
    end
    @span = Span.new
    @span.simple_calendar(object_day)
    @construction_schedules = @matter.construction_schedules.where(disclose: true)
    @target_schedules = @construction_schedules.where(start_date: @span.first_day..@span.last_day)
  end
  
  def report
    @reports = @matter.reports
    @report_cover = @matter.report_cover
    if @report_cover.present?
      @report_cover_images = [@report_cover.img_1_id, @report_cover.img_2_id, @report_cover.img_3_id, @report_cover.img_4_id]
    end
  end
  
  def invoice
    @invoice = Invoice.find_by(matter_id: @matter.id)
    @color_code = @invoice.plan_name.label_color.color_code
    @invoice_details = @invoice.invoice_details.order(sort_number: :asc).group_by{ |detail| detail[:category_id] }
  end

  def lost_password
  end
  
  private
    def set_estimate_matter
      @estimate_matter = current_client.estimate_matters.last
    end
    
    def set_matter
      @matter = Matter.find_by(estimate_matter_id: @estimate_matter.id)
    end
    
    def set_condition
      @condition = current_client.client_show_condition
    end
      
end
