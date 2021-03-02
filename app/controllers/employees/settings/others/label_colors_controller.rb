class Employees::Settings::Others::LabelColorsController < Employees::Settings::OthersController
  before_action :set_label_color, only: [:edit, :update, :destroy]
  before_action :before_status, only: [:edit, :destroy]
  
  def new
    @label_color = LabelColor.new
  end

  def create
    @label_color = LabelColor.new(label_color_params)
    if @label_color.save
      @responce = "success"
    else
      @responce = "failure"
    end
    set_label_colors
  end

  def edit
  end

  def update
    if params[:accept_type] != "4" && params[:label_color][:accept] != "1"  
      @label_color.errors.add(:accept, "のチェック必須")
      @responce = "failure"
    else
      if @label_color.update(label_color_params)
        @responce = "success"
        set_label_colors
      else
        @responce = "failure"
      end
    end
  end

  def index
  end

  def destroy
    if @accept_type == 4
      @label_color.destroy
      @responce = "success"
    else
      @responce = "failure"
    end
    set_label_colors
  end

  def sort
    from = params[:from].to_i + 1
    label_color = LabelColor.find_by(position: from)
    label_color.insert_at(params[:to].to_i + 1)
    set_label_colors
  end

  private
    def label_color_params
      params.require(:label_color).permit(:name, :color_code, :note)
    end

    def set_label_color
      @label_color = LabelColor.find(params[:id])
    end
    
    def before_status
      if PlanName.joins(:estimates).where(label_color_id: @label_color.id).present?
        alert_type_1 = true
      end
      if Staff.where(label_color_id: @label_color.id).present?
        alert_type_2 = true
      end
      if alert_type_1 && alert_type_2
        @accept_type = 1
      elsif alert_type_1
        @accept_type = 2
      elsif alert_type_2
        @accept_type = 3
      else
        @accept_type = 4
      end
    end
end

