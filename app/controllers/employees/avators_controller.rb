class Employees::AvatorsController < Employees::EmployeesController
  
  before_action :authenticate_admin_or_manager!
  before_action :target_user
  
  def create
    @target_user.avator.attach(params[:avator])
  end
  
  def avator_delete
    @target_user.avator.purge
  end
  
  private
    def target_user
      @target_user = MemberCode.find(params[:member_code_id]).parent
    end

end
