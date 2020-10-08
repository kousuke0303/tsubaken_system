class Employees::SuppliersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @suppliers = Supplier.all
  end

  def new
    @suppliers = Supplier.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end
end
