class Matter::MattersController < ApplicationController
  
  def index
  end
  
  def new
    @matter = Matter.new
  end
  
end
