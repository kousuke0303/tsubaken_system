class Api::V1::Clients::RegistrationsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  def update_self
    @client = Client.find(params[:id])
    if @client.update(client_params)
      render json: @client, serializer: ClientSerializer
    else
      render json: { status: "false", message: @client.errors.full_messages }
    end
  end

  private
    def client_params
      params.permit(:name, :gender, :login_id, :phone_1, :phone_2, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street)
    end
end
