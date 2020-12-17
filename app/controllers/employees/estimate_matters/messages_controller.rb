class Employees::EstimateMatters::MessagesController < ApplicationController
  layout "image_layout"

  before_action :current_estimate_matter

  def index
    @messages = current_estimate_matter.messages.select { |message| message.photo.attached? }
  end 
end