class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  def create
    # 受け取ったlogin_id
    login_id = params[:login_id]
    # 受け取ったlogin_idの先頭2文字
    login_id_lead = login_id.slice(0..1)
    # 受け取ったpassword
    password = params[:password]

    case login_id_lead
    when "AD"
      admin = Admin.find_by(login_id: login_id)
      if admin && admin.valid_password?(password)
        render json: admin, serializer: AdminSerializer
      else
        render json: { status: "false" }
      end
    when "MN"
      manager = Manager.find_by(login_id: login_id)
      if manager && manager.valid_password?(password)
        render json: manager, serializer: ManagerSerializer
      else
        render json: { status: "false" }
      end
    when "ST"
      staff = Staff.find_by(login_id: login_id)
      if staff && staff.valid_password?(password)
        render json: staff, serializer: StaffSerializer
      else
        render json: { status: "false" }
      end
    when "ES"
      external_staff = ExternalStaff.find_by(login_id: login_id)
      if external_staff && external_staff.valid_password?(password)
        render json: external_staff, serializer: ExternalStaffSerializer
      else
        render json: { status: "false" }
      end
    when "CL"
      client = Client.find_by(login_id: login_id)
      if client && client.valid_password?(password)
        render json: client, serializer: ClientSerializer
      else
        render json: { status: "false" }
      end
    else
      render json: { status: "false" }
    end
  end
end
