class Employees::EstimateMattersController < ApplicationController
  before_action :authenticate_employee!

  def index
    @estimate_matters = EstimateMatter.all
  end

  def new
    @estimate_matter = EstimateMatter.new
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
    def set_estimate_matter
    end

    def estimate_matter_params
    end
end
