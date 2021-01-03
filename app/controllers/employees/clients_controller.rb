class Employees::ClientsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params.merge(password: "password", password_confirmation: "password"))
    if @client.save
      flash[:success] = "顧客を作成しました。"
      redirect_to employees_client_url(@client)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @estimate_matters = @client.estimate_matters
  end

  def edit
  end

  def index
    @clients = Client.all
    if params[:name].present?
      @clients = @clients.get_by_name params[:name]
    end
  end

  def update
    if @client.update(client_params)
      @client_success_flash = "顧客情報を更新しました。"
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @client.destroy ? flash[:success] = "顧客を削除しました。" : flash[:alert] = "顧客を削除できませんでした。"
    redirect_to employees_clients_url
  end

  private
    def client_params
      params.require(:client).permit(:name, :kana, :gender, :login_id, :phone_1, :phone_2, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street)
    end

    def set_client
      @client = Client.find(params[:id])
    end
end
