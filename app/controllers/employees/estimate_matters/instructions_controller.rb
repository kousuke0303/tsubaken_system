class Employees::EstimateMatters::InstructionsController < Employees::EmployeesController
  before_action :set_estimate_matter
  before_action :set_instruction, only: [:show, :edit, :update, :destroy]
  before_action :preview_display, only: :preview

  def index
    @instructions = @estimate_matter.instructions.order(:position)
  end
  
  def new
    @instruction = @estimate_matter.instructions.new
  end
  
  def create
    if @instruction = @estimate_matter.instructions.create(instruction_params)
      flash[:success] = "説明書項目を追加しました"
      redirect_to employees_estimate_matter_instructions_url(@estimate_matter)
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @instruction.update(instruction_params)
      flash[:success] = "#{@instruction.title}を更新しました"
      redirect_to employees_estimate_matter_instructions_url(@estimate_matter)
    end
  end
  
  def destroy
    if @instruction.destroy
      flash[:alert] = "#{@instruction.title}を削除しました"
      redirect_to employees_estimate_matter_instructions_url(@estimate_matter)
    end
  end
  
  def preview
    @instructions = @estimate_matter.instructions.order(:position)
  end
  
  def sort
    from = params[:from].to_i + 1
    instruction = Instruction.find_by(position: from)
    instruction.insert_at(params[:to].to_i + 1)
    @instructions = @estimate_matter.instructions.order(:position)
  end
  
  
  private
    def instruction_params
      params.require(:instruction).permit(:title, :content)
    end
    
    def set_instruction
      @instruction = Instruction.find(params[:id])
    end
  
end
