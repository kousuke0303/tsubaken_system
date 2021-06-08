class Employees::Matters::MembersController < Employees::EmployeesController

  before_action :set_matter_by_matter_id
  before_action :all_staff_and_external_staff_code, only: :edit
  
  def edit
    if params[:retire_staff_id].present?
      @staff = Staff.find(params[:retire_staff_id])
      @staff_codes = @matter.member_codes.joins(:staff).select('member_codes.*')
    elsif params[:retire_external_staff_id].present?
      @external_staff = ExternalStaff.find(params[:retire_external_staff_id])
      @supplier = @external_staff.supplier
      @supplier_staff_codes_ids = @supplier.external_staffs.joins(:member_code)
                                                           .select('external_staffs.*, member_codes.id AS member_code_id')
    end
  end
  
  def member_change_for_staff
    ActiveRecord::Base.transaction do
      # 既存のスタッフ消去
      registed_staff_code_ids = @matter.member_codes.where.not(staff_id: nil).ids
      delete_matter_member_codes = MatterMemberCode.where(matter_id: @matter.id, member_code_id: registed_staff_code_ids) 
      delete_matter_member_codes.delete_all
      # 新規スタッフ登録
      params[:matter][:staff_ids].each do |staff_code_id|
        @matter.matter_member_codes.create(member_code_id: staff_code_id)
      end
    end
    flash[:success] = "当社スタッフを変更しました"
    
    #### 退職処理と案件詳細に分岐 #########
    if params[:matter][:redirect_staff_id].present?
      @staff = Staff.find(params[:matter][:redirect_staff_id])
      redirect_to employees_staff_retirements_url(@staff)
    else
      redirect_to employees_matter_url(@matter)
    end
  end
  
  def member_change_for_supplier_staff
    ActiveRecord::Base.transaction do
      # 既存の外注企業スタッフ消去
      @supplier = Supplier.find(params[:matter][:supplier_id])
      supplier_staff_codes_ids = @supplier.external_staffs.ids
      registed_staff_code_ids = @matter.member_codes.where(external_staff_id: supplier_staff_codes_ids).ids
      delete_matter_member_codes = MatterMemberCode.where(matter_id: @matter.id, member_code_id: registed_staff_code_ids) 
      delete_matter_member_codes.delete_all
      # 新規スタッフ登録
      params[:matter][:member_code_ids].each do |supplier_staff_code_id|
        @matter.matter_member_codes.create(member_code_id: supplier_staff_code_id)
      end
    end
    flash[:success] = "#{@supplier.name}の担当スタッフを変更しました"
    
    #### 退職処理と案件詳細に分岐 #########
    if params[:matter][:redirect_external_staff_id].present?
      @external_staff = ExternalStaff.find(params[:matter][:redirect_external_staff_id])
      redirect_to employees_external_staff_retirements_url(@external_staff)
    else
      redirect_to employees_matter_url(@matter)
    end
  end

end
