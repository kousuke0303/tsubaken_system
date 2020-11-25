class Employees::QuotationsController < ApplicationController
  before_action :authenticate_employee!

  def index
    @quotations = Quotation.all.includes(:client)
  end

  def new
    @quotation = Quotation.new
    @clients = Client.all
    @kinds = Kind.all
    @categories = Category.all
  end

  def create
    @quotation = Quotation.new(quotation_params)
    if @quotation.save
      flash[:notice] = "見積書を作成しました。"
      redirect_to employees_quotations_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    @clients = Client.all
    @kinds = Kind.all
    @categories = Category.all
  end

  def update
    if @quotation.update(quotation_params)
      flash[:notice] = "見積書を更新しました。"
      redirect_to employees_quotations_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy

    redirect_to employees_quotations_url
  end

  private
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    def quotation_params
      params.require(:quotation).permit(:title, client_id, :kind_id, :amount)
    end
end
