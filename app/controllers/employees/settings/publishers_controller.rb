class Employees::Settings::PublishersController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_publishers, only: :index
  before_action :set_publisher, only: [:edit, :update, :destroy, :sort]

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(publisher_params)
    if @publisher.save
      flash[:success] = "発行元を作成しました。"
      redirect_to employees_settings_publishers_url
    end
  end

  def edit
  end

  def update
    if @publisher.update(publisher_params)
      flash[:success] = "発行元を更新しました。"
      redirect_to employees_settings_publishers_url
    end
  end

  def index
  end

  def destroy
    @publisher.destroy ? flash[:success] = "発行元を削除しました。" : flash[:alert] = "発行元を削除できませんでした。"
    redirect_to employees_settings_publishers_url
  end

  def sort
    from = params[:from].to_i + 1
    publisher = Publisher.find_by(position: from)
    publisher.insert_at(params[:to].to_i + 1)
    set_publishers
  end

  private
    def publisher_params
      params.require(:publisher).permit(:name, :postal_code, :prefecture_code, :address_city, :address_street, :phone, :fax, :image)
    end

    def set_publisher
      @publisher = Publisher.find(params[:id])
    end
end
