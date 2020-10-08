class Employees::SuppliersController < ApplicationController
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
end
