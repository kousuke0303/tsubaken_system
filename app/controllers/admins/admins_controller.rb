class Admins::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_one_month

  def top
  end
  
  def index
  end
end
