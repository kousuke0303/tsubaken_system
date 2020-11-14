class Api::V1::Employees::MattersController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_matter, only: [:update, :show, :destroy]

  def create
    matter = Matter.new(matter_params)
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
      params.permit(:id, :title, :actual_spot, :zip_code, :status, :content, :scheduled_started_on, :started_on, :scheduled_finished_on,
                    :finished_on, :maintenanced_on, :client_id, { manager_ids: [] }, { staff_ids: [] }, { supplier_ids: [] })
    end
end
