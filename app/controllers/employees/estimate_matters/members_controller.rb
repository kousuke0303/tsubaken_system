class Employees::EstimateMatters::MembersController < Employees::EmployeesController

  before_action :set_estimate_matter
  before_action :all_staff_and_external_staff_code, only: :edit

  def edit
    if params[:retire_staff_id].present?
      @staff = Staff.find(params[:retire_staff_id])
      @staff_codes = @estimate_matter.member_codes.joins(:staff).select('member_codes.*')
    elsif params[:retire_external_staff_id].present?
      @external_staff = ExternalStaff.find(params[:retire_external_staff_id])
      @vendor = @external_staff.vendor
      @vendor_staff_codes_ids = @vendor.external_staffs.joins(:member_code)
                                                           .select('external_staffs.*, member_codes.id AS member_code_id')
    end
  end

  def member_change_for_staff
    ActiveRecord::Base.transaction do
      # 既存のスタッフ消去
      registed_staff_code_ids = @estimate_matter.member_codes.where.not(staff_id: nil).ids
      delete_matter_member_codes = EstimateMatterMemberCode.where(estimate_matter_id: @estimate_matter.id, member_code_id: registed_staff_code_ids)
      delete_matter_member_codes.delete_all
      # 新規スタッフ登録
      params[:estimate_matter][:staff_ids].each do |staff_code_id|
        @estimate_matter.estimate_matter_member_codes.create(member_code_id: staff_code_id)
      end
    end
    flash[:success] = "当社スタッフを変更しました"

    #### 退職処理と案件詳細に分岐 #########
    if params[:estimate_matter][:redirect_staff_id].present?
      @staff = Staff.find(params[:estimate_matter][:redirect_staff_id])
      redirect_to employees_staff_retirements_url(@staff)
    else
      redirect_to employees_estimate_matter_url(@estimate_matter)
    end
  end

  def member_change_for_vendor_staff
    ActiveRecord::Base.transaction do
      # 既存の外注企業スタッフ消去
      @vendor = Vendor.find(params[:estimate_matter][:vendor_id])
      vendor_staff_codes_ids = @vendor.external_staffs.ids
      registed_staff_code_ids = @estimate_matter.member_codes.where(external_staff_id: vendor_staff_codes_ids).ids
      delete_matter_member_codes = EstimateMatterMemberCode.where(estimate_matter_id: @estimate_matter.id, member_code_id: registed_staff_code_ids)
      delete_matter_member_codes.delete_all
      # 新規スタッフ登録
      params[:estimate_matter][:member_code_ids].each do |vendor_staff_code_id|
        @estimate_matter.estimate_matter_member_codes.create(member_code_id: vendor_staff_code_id)
      end
    end
    flash[:success] = "#{@vendor.name}の担当スタッフを変更しました"

    #### 退職処理と案件詳細に分岐 #########
    if params[:estimate_matter][:redirect_external_staff_id].present?
      @external_staff = ExternalStaff.find(params[:estimate_matter][:redirect_external_staff_id])
      redirect_to employees_external_staff_retirements_url(@external_staff)
    else
      redirect_to employees_estimate_matter_url(@estimate_matter)
    end
  end

end
