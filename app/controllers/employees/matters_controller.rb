class Employees::MattersController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter, except: [:new, :create, :index]
  before_action :set_employees, only: [:new, :edit, :change_member]
  before_action :set_suppliers, only: :edit
  before_action :can_access_only_matter_of_being_in_charge
  before_action :set_staff, only: :change_member

  # 見積案件から案件を作成ページ
  def new
    @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @matter = Matter.new
    set_estimates_with_plan_names_and_label_colors
  end

  # 見積案件から案件を作成
  def create
    ActiveRecord::Base.transaction do
      estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
      @matter = estimate_matter.build_matter(estimate_matter.attributes.merge(scheduled_started_on: params[:matter][:scheduled_started_on],
                                                                              scheduled_finished_on: params[:matter][:scheduled_finished_on]))
      @matter.save!                                                          
      estimate = Estimate.find(params[:matter]["estimate_id"].to_i)
      adopted_estimate = @matter.build_adopted_estimate(total_price: estimate.total_price, discount: estimate.discount, plan_name_id: estimate.plan_name_id)                                                               
      adopted_estimate.save!
      estimate.estimate_details.each do |detail|
        adopted_estimate.adopted_estimate_details.create!(sort_number: detail.sort_number, category_id: detail.category_id, category_name: detail.category_name,
                                                          material_id: detail.material_id, material_name: detail.material_name, construction_id: detail.construction_id,
                                                          construction_name: detail.construction_name, service_life: detail.service_life, note: detail.note,
                                                          unit: detail.unit, price: detail.price, amount: detail.amount, total: detail.total)
      end
      @responce = "success"
    rescue
      @responce = "failed"
    end
  end

  def index
    if current_admin || current_manager
      @matters = Matter.all
    elsif current_staff
      @staff_matters = current_staff.matters
    elsif current_external_staff
      @external_staff_matters = current_external_staff.matters
    end
    # 進行状況での絞り込みがあった場合
    if params[:status] && params[:status] == "not_started"
      @matters = @matters.not_started
    elsif params[:status] && params[:status] == "progress"
      @matters = @matters.progress
    elsif params[:status] && params[:status] == "completed"
      @matters = @matters.completed
    end
  end

  def show
    @staffs = @matter.staffs
    @external_staffs = @matter.external_staffs
    @suppliers = @matter.suppliers
    set_classified_tasks(@matter)        
    @client = @matter.client
    @address = "#{ @matter.prefecture_code }#{ @matter.address_city }#{ @matter.address_street }"
    @estimate_matter = @matter.estimate_matter
    set_estimates_with_plan_names_and_label_colors
    @adopted_estimate = @matter.adopted_estimate
    @plan_name = @adopted_estimate.plan_name
    @color_code = @plan_name.label_color.color_code
    @adopted_estimate_details = @adopted_estimate.adopted_estimate_details.order(sort_number: :asc).group_by{ |detail| detail[:category_id] }
    @message = true if params[:type] == "success"
  end

  def edit
    @estimates = @matter.estimate_matter.estimates.with_plan_names_and_label_colors
  end

  def update
    if @matter.update(matter_params)
      delete_matter_relation_table
      flash[:success] = "案件情報を更新しました"
      redirect_to employees_matter_url(@matter)
    end
  end

  def destroy
    @matter.destroy ? flash[:success] = "案件を削除しました" : flash[:alert] = "案件を削除できませんでした"
    redirect_to employees_matters_url
  end
  
  def change_estimate
    @matter.update(estimate_id: params[:matter][:estimate_id])
  end
  
  def change_member
  end
  
  def update_member
    @matter.update(matter_params)
    delete_matter_relation_table
    flash[:success] = "#{@matter.title}の担当者を変更しました"
    @staff = Staff.find(params[:matter][:staff_id])
    redirect_to retirement_process_employees_staff_url(@staff)
  end

  private
    def set_matter
      @matter = Matter.find(params[:id])
    end

    def matter_params
      params.require(:matter).permit(:title, :content, :postal_code, :prefecture_code, :address_city, :address_street, :scheduled_started_on, 
                                     :scheduled_finished_on, :status, :estimate_id, :started_on, :finished_on, :maintenanced_on,
                                     { staff_ids: [] }, { external_staff_ids: [] }, { supplier_ids: [] })
    end
    
    def matter_staff_external_staff_client_params
      params.permit({ staff_ids: [] }, { external_staff_ids: [] }, { supplier_ids: [] })
    end
    
    def delete_matter_relation_table  
      @matter.matter_staffs.delete_all unless params[:matter][:staff_ids].present?      
      @matter.matter_external_staffs.delete_all unless params[:matter][:external_staff_ids].present?
    end
end
