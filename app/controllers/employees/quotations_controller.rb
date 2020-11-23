class Employees::QuotationsController < ApplicationController
  before_action :authenticate_employee!

  def index
    @quotations = Quotation.all
  end

  def new
    @quotation = Quotation.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    def quotation_params
    end
end
