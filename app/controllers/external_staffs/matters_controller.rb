class ExternalStaffs::MattersController < ApplicationController
  before_action :authenticate_external_staff!
  before_action :set_matter, except: :index
  before_action :self_vendor_matter!, except: :index

  def index
    @matters = Matter.joins(:member_codes).where(member_codes: { id: login_user.member_code.id })
    # 進行状況での絞り込みがあった場合
    if params[:status] && params[:status] == "not_started"
      @matters = @matters.where(status: "not_started")
    elsif params[:status] && params[:status] == "progress"
      @matters = @matters.where(status: "progress")
    elsif params[:status] && params[:status] == "completed"
      @matters = @matters.where(status: "completed")
    end
  end

  def show
    set_matter_detail_valiable
    @client = @matter.client
    @estimate_matter = @matter.estimate_matter
    @message = true if params[:type] == "success"
    @images = @matter.images.select{ |image| image.image.attached? }
    gon.matter_id = @matter.id
    @construction_schedules = @matter.construction_schedules.includes(:materials, :vendor).order_start_date
  end

  def registor_started_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(started_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_reference_date
  end

  def registor_finished_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(finished_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_reference_date
  end

  private
    def set_matter_detail_valiable
      @address = "#{ @matter.prefecture_code }#{ @matter.address_city }#{ @matter.address_street }"
      @vendors = @matter.vendors
    end

    def set_matter
      @matter = Matter.find(params[:id])
    end
    
    def self_vendor_matter!
      unless @matter.member_codes.where(id: login_user.member_code.id).present?
        sign_out(login_user)
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_url
      end
    end

end
