class Api::V1::Employees::Settings::IndustriesController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_industry, only: [:update, :destroy]

  def create
    industry = Industry.new(industry_params)
    if industry.save
      render json: industry, serializer: IndustrySerializer
    else
      render json: { status: "false", message: industry.errors.full_messages }
    end
  end

  def update
    if @industry.update(industry_params)
      render json: @industry, serializer: IndustrySerializer
    else
      render json: { status: "false", message: @industry.errors.full_messages }
    end
  end

  def destroy
    if @industry.destroy
      render json: @industry, serializer: IndustrySerializer
    else
      render json: { status: "false", message: @industry.errors.full_messages }
    end
  end

  private
    def industry_params
      params.permit(:name)
    end

    def set_industry
      @industry = Industry.find(params[:id])
    end
end
