class Api::V1::ApplicationController < ApplicationController
  def check_token_and_key_to_api
    unless params[:api_authenticate_token] == ENV["API_AUTHENTICATE_TOKEN"] && params[:api_authenticate_key] == ENV["API_AUTHENTICATE_KEY"]
      render json: { status: "false", message: "認証トークンまたは認証キーが不正です" }
    end
  end
end
