class Api::V1::Employees::VendorsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_vendor, only: [:update, :destroy]

  def index
    vendors = Vendor.all
    render json: vendors, serializer: VendorSerializer
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: vendor, serializer: VendorSerializer
    else
      render json: { status: "false", message: vendor.errors.full_messages }
    end
  end

  def update
    if @vendor.update(vendor_params)
      render json: @vendor, serializer: VendorSerializer
    else
      render json: { status: "false", message: @vendor.errors.full_messages }
    end
  end

  def destroy
    if @vendor.destroy
      render json: @vendor, serializer: VendorSerializer
    else
      render json: { status: "false", message: @vendor.errors.full_messages }
    end
  end

  private
    def vendor_params
      params.permit(:name, :postal_code, :prefecture_code, :address_city, :address_street, :representative, :phone_1, :phone_2, :fax, :email)
    end

    def set_vendor
      @vendor = Vendor.find(params[:id])
    end
end
