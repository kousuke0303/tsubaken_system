class Employees::MattersController < ApplicationController
  before_action :authenticate_employee!

  def index
  end
  
  def new
  end

  def create
  end

  def show
  end

  def edit
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
      params.require(:matter).permit(:name)
    end
end
