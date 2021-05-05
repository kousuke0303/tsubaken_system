class Clients::ClientsController < ApplicationController
  before_action :authenticate_client!
  before_action :matter_default_task_requests, only:[:index]
  before_action :preview_display, only: [:estimate, :invoice]
  
  
  def top
  end
  
  def detail
    target = params[:target].split('#')
    if target[0] == "estimate_matter"
      @estimate_matter = current_client.estimate_matters.find(target[1])
    elsif target[0] == "matter"
      @matter = current_client.matters.find(target[1])
      @construction_schedules = @matter.construction_schedules
                                       .where(disclose: true)
                                       .order_reference_date
    end
  end
  
  def estimate
    @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @estimates = @estimate_matter.estimates.with_plan_names_and_label_colors
    @estimate_details = @estimates.with_estimate_details
  end
  
  def invoice
    @matter = Matter.find(params[:matter_id])
    @estimate_matter = @matter.estimate_matter
    @invoice = Invoice.find_by(matter_id: @matter.id)
    @color_code = @invoice.plan_name.label_color.color_code
    @invoice_details = @invoice.invoice_details.order(sort_number: :asc).group_by{ |detail| detail[:category_id] }
  end

  def lost_password
  end
end
