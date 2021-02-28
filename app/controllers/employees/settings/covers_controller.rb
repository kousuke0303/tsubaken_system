class Employees::Settings::CoversController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_cover, only: [:edit, :update, :destroy]

  def new
    @cover = Cover.new
  end

  def create
    @cover = Cover.new(cover_params.merge(default: true))
    if @cover.save
      @responce = "success"
      @covers = Cover.where(default: true)
    else
      @responce = "failure"
    end
  end

  def edit
  end

  def update
    if @cover.update(cover_params)
      @responce = "success"
      @covers = Cover.where(default: true)
    else
      @responce = "failure"
    end
  end

  def destroy
    @cover.destroy
    @covers = Cover.where(default: true)
  end

  private
    def cover_params
      params.require(:cover).permit(:title, :content, :default)
    end

    def set_cover
      @cover = Cover.find(params[:id])
    end
end
