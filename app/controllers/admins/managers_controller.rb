class Admins::ManagersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_manager_by_admin, only: [:show, :edit, :update, :destroy]

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new
  end

  def index
    @managers = Manager.all
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
    def admin_manager_params
    end

    def set_manager_by_admin
      @manager = Manager.find(params[:id])
    end
end
