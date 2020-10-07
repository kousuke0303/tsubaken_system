class Admins::ManagersController < ApplicationController
  before_action :authenticate_admin!

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
end
