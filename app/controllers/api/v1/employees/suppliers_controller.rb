class Api::V1::Employees::SuppliersController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_supplier, only: [:update, :destroy]

  def index
    suppliers = Supplier.all
    render json: suppliers, serializer: SupplierSerializer
  end

  def create
    supplier = Supplier.new(supplier_params)
    if supplier.save
      render json: supplier, serializer: SupplierSerializer
    else
      render json: { status: "false", message: supplier.errors.full_messages }
    end
  end

  def update
    if @supplier.update(supplier_params)
      render json: @supplier, serializer: SupplierSerializer
    else
      render json: { status: "false", message: @supplier.errors.full_messages }
    end
  end

  def destroy
    if @supplier.destroy
      render json: @supplier, serializer: SupplierSerializer
    else
      render json: { status: "false", message: @supplier.errors.full_messages }
    end
  end

  private
    def supplier_params
      params.permit(:name, :address, :zip_code, :representative, :phone_1, :phone_2, :fax, :email)
    end

    def set_supplier
      @supplier = Supplier.find(params[:id])
    end
end
