class Employees::Clients::ConditionsController < Employees::ClientsController

  def update
    condition = ClientShowCondition.find(params[:id])
    client = condition.client
    if condition.update(condition_params)
      flash[:success] = "#{client.name}の閲覧可能項目を更新しました"
      redirect_to employees_client_path(client)
    else
      flash.now[:alert] = "#{client.name}の閲覧可能項目を更新できませんでした"
      render 'employees/clients/show'
    end
  end
  
  private
   def condition_params
     params.permit(:certificate, :estimate, :construction_schedule, :report, :invoice)
   end
end
