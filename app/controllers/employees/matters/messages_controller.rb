class Employees::Matters::MessagesController < ApplicationController
  layout "image_layout"

  before_action :current_matter

  def index
    @messages = current_matter.messages.select { |message| message.photo.attached? }
  end 
end