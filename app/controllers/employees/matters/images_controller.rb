class Employees::Matters::ImagesController < Employees::EmployeesController
  before_action :other_tab_display, only: :index
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :set_matter

  def new
    @image = Image.new
  end

  def create
    if params[:image][:image].nil?
      flash[:alert] = "画像の取り込みに失敗しました"
      redirect_to employees_matter_images_path(@matter)
    else
      @image = @matter.images.new(image_params)
      if @image.save
        @responce = "success"
        flash[:success] = "画像を取り込みました"
        redirect_to employees_matter_images_path(@matter)
      end
    end
  end

  def index
    @images = @matter.images
    @all_images = @images.where(content: params[:content]).order(shooted_on: "DESC").select { |image| image.image.attached? }
    if params[:content].present?
      @serch_word = params[:content].chomp
      @target_images = @images.where(content: params[:content]).order(shooted_on: "DESC").select { |image| image.image.attached? }
    else
      @target_images = @images.order(shooted_on: "DESC", created_at: "DESC").select { |image| image.image.attached? }
    end
    @image_tags = @images.pluck(:content).uniq
    @band_key = @matter.band_connection.band_key
    search_image(@band_key)
  end
  
  def edit
  end
  
  def update
    unless params[:image][:report_cover].present?
      params[:image][:report_cover] = false
    end
    unless params[:image][:report].present?
      params[:image][:report] = false
    end
    if @image.update(image_content_and_shooted_on_params)
      @responce = "success"
      set_index_variable
    end
  end
  
  def destroy
    @image.destroy
    set_index_variable
  end
  
  def save_for_band_image
    ActiveRecord::Base.transaction do
      params[:matter][:images].each.with_index(1) do |params_image, index|
        # 画像を取り込んでフォルダに格納
        temporary_storage_for_image(params_image["image"], index, @matter)
        # 新規テーブル作成・保存
        image_model = @matter.images.new(author: params[:matter][:author],
                                                        content: params[:matter][:content].chomp,
                                                        shooted_on: params[:matter][:shooted_on],
                                                        default_file_path: params_image["image"])
        image_model.image.attach(io: File.open(@file_path), filename: @file_name, content_type: "image/jpeg")
        image_model.save!
        File.delete(@file_path) # ファイル削除
      end
      set_index_variable
    end
  rescue
    @images = @matter.images.order(shooted_on: "DESC", created_at: "DESC").select { |image| image.images.attached? }
  end
  
  private
  
    def set_matter
      @matter = Matter.find(params[:matter_id])
    end
    
    def image_params
      params.require(:image).permit(:content, :shooted_on, :image, :matter_id)
    end
    
    def image_content_and_shooted_on_params
      params.require(:image).permit(:content, :shooted_on, :report_cover, :report)
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
    
    def set_index_variable
      @images = @matter.images
      @all_images = @images.where(content: params[:content]).order(shooted_on: "DESC").select { |image| image.image.attached? }
      @target_images = @images.order(shooted_on: "DESC").select { |image| image.image.attached? }
      @image_tags = @images.pluck(:content).uniq
      @band_key = @matter.band_connection.band_key
      search_image(@band_key)
    end
end
