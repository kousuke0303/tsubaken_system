class Employees::Matters::ClientsController < Employees::EmployeesController
  before_action :authenticate_employee_except_external_staff!
  before_action :set_matter_by_matter_id
  before_action :set_client
  
  def edit
  end
  
  def update
    if @client.update(client_params)
      flash[:success] = "#{@client.name}の情報を更新しました"
      redirect_to employees_matter_url(@matter)
    end
  end
  
  private
    
    def set_client
      @client = Client.find(params[:id])
    end
    
    def client_params
      params.require(:client).permit(:name, :kana, :gender, :login_id, :avaliable, :phone_1, :phone_2, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street)
    end

end
