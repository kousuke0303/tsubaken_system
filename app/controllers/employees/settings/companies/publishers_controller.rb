class Employees::Settings::Companies::PublishersController < Employees::Settings::CompaniesController
  before_action :set_publisher, except: [:new, :create]

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(publisher_params)
    if @publisher.save
      flash[:success] = "発行元を作成しました。"
      redirect_to employees_settings_companies_url
    end
  end

  def edit
    @submit_type = "edit"
  end

  def update
    if @publisher.update(publisher_params)
      flash[:success] = "発行元を更新しました。"
      redirect_to employees_settings_companies_url
    end
  end

  def destroy
    if @publisher.estimate_matters.present?
      @error_type = "関連する見積があるため、削除できません"
      @responce = "failure"
    elsif @publisher.matters.present?
      @error_type = "関連する請求があるので削除はできません"
      @responce = "failure"
    else
      @publisher.destroy
      @responce = "success"
    end
    set_publishers
  end

  def sort
    from = params[:from].to_i + 1
    publisher = Publisher.find_by(position: from)
    publisher.insert_at(params[:to].to_i + 1)
    set_publishers
  end
  
  def image_change
    @publisher.update(image: params[:image])
    @publishers = Publisher.order(position: :asc)
    @submit_type = "edit"
  end
  
  def image_delete
    @publisher.image.purge_later
    @submit_type = "image_delete"
    @publishers = Publisher.order(position: :asc)
  end

  private
    def publisher_params
      params.require(:publisher).permit(:name, :postal_code, :prefecture_code, :address_city, :address_street, :phone, :fax, :image)
    end

    def set_publisher
      @publisher = Publisher.find(params[:id])
    end
end
