class Employees::ClientsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_client, only: [:show, :edit, :update, :destroy, :reset_password]

  def new
    @client = Client.new
  end

  def create
    begin
      login_id = "CL-" + (0...9).map{ ("a".."z").to_a[rand(26)] }.join
      raise if Client.all.where(login_id: login_id).present?
    rescue
      retry
    end
    @client = Client.new(client_params.merge(login_id: login_id, password: "password", password_confirmation: "password"))
    if @client.save
      flash[:success] = "顧客を作成しました"
      redirect_to employees_client_url(@client)
    end
  end

  def show
    @client_estimate_matters = EstimateMatter.left_joins(:matter).where(matters: {estimate_matter_id: nil}).where(client_id: @client.id)
    @client_matters =  Matter.joins(:estimate_matter).where(estimate_matters: { client_id: @client.id }).select("matters.*, estimate_matters.*")
  end

  def edit
  end

  def index
    @clients = Client.has_matter
    @no_matter_clients = Client.not_have_matter
  end
  
  def search_index
    @search_clients = Client.get_by_name params[:name]
    @search_clients.present? ? @display_type = "success" : @display_type = "failure"
  end

  def update
    @client.update(client_params) ? @responce = "success" : @responce = "failed"
  end

  def destroy
    @client.destroy ? flash[:success] = "顧客を削除しました" : flash[:alert] = "顧客を削除できませんでした"
    redirect_to employees_clients_url
  end

  def reset_password
    password = (0...8).map{ ("a".."z").to_a[rand(26)] }.join
    @client.update(tmp_password: password, password: password, password_confirmation: password)
    flash[:notice] = "顧客の仮パスワードを発行しました"
    redirect_to employees_client_path(@client)
  end

  private
    def client_params
      params.require(:client).permit(:name, :kana, :gender, :login_id, :avaliable, :phone_1, :phone_2, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street)
    end

    def set_client
      @client = Client.find(params[:id])
    end
end
