class Api::V1::Employees::MattersController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_matter, only: [:update, :show, :destroy]

  def create
    client = Client.find(params[:client_id])
    matter = client.matters.new(matter_params)
    if matter.save
      render json: matter, serializer: MatterSerializer
    else
      render json: { status: "false", message: matter.errors.full_messages }
    end
  end

  def update
  end

  def destroy
  end

  private
    def set_matter
      @matter = Matter.find(params[:id])
    end

    def matter_params
      params.permit(:id, :title, :actual_spot, :postal_code, :status, :content, :scheduled_started_on, :started_on, :scheduled_finished_on,
                    :finished_on, :maintenanced_on, :client_id, { ids: [] }, { staff_ids: [] }, { supplier_ids: [] })
    end
end
