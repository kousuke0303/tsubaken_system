class Api::V1::ApplicationController < ApplicationController
  def check_token_and_key_to_api
    unless params[:api_authenticate_token] == ENV["API_AUTHENTICATE_TOKEN"] && params[:api_authenticate_key] == ENV["API_AUTHENTICATE_KEY"]
      render json: { status: "false", message: "認証トークンまたは認証キーが不正です。" }
    end
  end

  def set_resource
    begin
      if params[:auth].eql?("admin")
        @resource = Admin.find(params[:id])
      elsif params[:auth].eql?("manager")
        @resource = Manager.find(params[:id])
      elsif params[:auth].eql?("staff")
        @resource = Staff.find(params[:id])
      elsif params[:auth].eql?("external_staff")
        @resource = ExternalStaff.find(params[:id])
      elsif params[:auth].eql?("client")
        @resource = Client.find(params[:id])
      else
        render json: { status: "false", message: "アカウント情報の取得に失敗しました。" }
      end
    end
  rescue
    render json: { status: "false", message: "アカウント情報の取得に失敗しました。" }
  end
end
