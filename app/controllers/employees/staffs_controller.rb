class Employees::StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  def new
    @staff = Staff.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def show
  end

  def destroy
  end

  private
    def staff_params
      params.require(:staff).permit(:name, :employee_id, :phone, :email, :birthed_on, :zipcode, :address, :joined_on, :resigned_on)
    end
end
