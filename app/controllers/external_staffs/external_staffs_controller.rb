class ExternalStaffs::ExternalStaffsController < ApplicationController
  before_action :authenticate_external_staff!

  def top
  end
end
