class Employees::ClientsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def new
    @client = Client.new
  end

  def create
  end

  def show
  end

  def index
    @clients = Client.all
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def set_client
      @client = Client.find(params[:id])
    end
end
