class Employees::ClientsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_client, only: [:show, :update, :destroy]

  def create
    @client = Client.new(client_params.merge(password: "password", password_confirmation: "password"))
    if @client.save
      flash[:success] = "顧客を作成しました"
      redirect_to employees_client_url(@client)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @matters = @client.matters
  end

  def index
    @clients = Client.all
    @client = Client.new
  end

  def update
    if @client.update(client_params)
      flash[:success] = "顧客情報を更新しました"
      redirect_to employees_client_url(@client)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @client.destroy ? flash[:success] = "顧客を削除しました" : flash[:alert] = "顧客を削除できませんでした"
    redirect_to employees_clients_url
  end

  private
    def client_params
      params.require(:client).permit(:name, :gender, :login_id, :phone_1, :phone_2, :email, :birthed_on, :zipcode, :address)
    end

    def set_client
      @client = Client.find(params[:id])
    end
end
