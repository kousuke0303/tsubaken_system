class Api::V1::Employees::TasksController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  private
    def set_matter
      @matter = Matter.find(params[:matter_id])
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
