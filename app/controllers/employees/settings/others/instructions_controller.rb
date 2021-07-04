class Employees::Settings::Others::InstructionsController < Employees::Settings::OthersController
  
  before_action :set_instruction, only: [:edit, :update, :destroy]
  
  def new
    @instruction = Instruction.new
  end

  def create
    @instruction = Instruction.new(instruction_params.merge(default: true))
    if @instruction.save
      @responce = "success"
      @instructions = Instruction.where(default: true)
    else
      @responce = "failure"
    end
  end

  def edit
  end

  def update
    if @instruction.update(instruction_params)
      @responce = "success"
      @instructions = Instruction.where(default: true)
    else
      @responce = "failure"
    end
  end
  
  def destroy
    if  @instruction.destroy
      @responce = "success"
      @instructions = Instruction.where(default: true)
    else
      @responce = "failure"
    end
  end
  
  private
    def instruction_params
      params.require(:instruction).permit(:title, :content)
    end
    
    def set_instruction
      @instruction = Instruction.find(params[:id])
    end

end
