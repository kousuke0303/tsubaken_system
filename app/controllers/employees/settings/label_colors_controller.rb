class Employees::Settings::LabelColorsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_label_color, only: [:edit, :update, :destroy]
  before_action :set_label_colors, only: :index

  def new
    @label_color = LabelColor.new
  end

  def create
    @label_color = LabelColor.new(label_color_params)
    if @label_color.save
      flash[:success] = "ラベルカラーを作成しました。"
      redirect_to employees_settings_label_colors_url
    end
  end

  def edit
  end

  def update
    if @label_color.update(label_color_params)
      flash[:success] = "ラベルカラーを更新しました。"
      redirect_to employees_settings_label_colors_url
    end
  end

  def index
  end

  def destroy
    @label_color.destroy ? flash[:success] = "ラベルカラーを削除しました。" : flash[:alert] = "ラベルカラーを削除できませんでした。"
    redirect_to employees_settings_label_colors_url
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
end
