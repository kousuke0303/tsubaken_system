class Admins::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :matter_default_task_requests, only:[:index]
  before_action :set_one_month

  def top
  end
end
