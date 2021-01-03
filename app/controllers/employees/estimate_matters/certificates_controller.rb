class Employees::EstimateMatters::CertificatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :current_estimate_matter
  before_action :set_certificate, only: [:edit, :update, :destroy]
  before_action :set_certificates, only: [:new, :edit]

  def new
    @certificate = Certificate.new
    @images = current_estimate_matter.images.select { |image| image.images.attached? }
  end

  def create
    @certificate = current_estimate_matter.certificates.new(certificate_params.merge(default: true))
    if @certificate.save
      flash[:success] = "診断書を作成しました。"
      redirect_to employees_estimate_matter_images_url(current_estimate_matter)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    @image = Image.find_by(params[:image_id])
  end

  def update
    if @certificate.update(certificate_params)
      flash[:success] = "診断書を更新しました。"
      redirect_to employees_estimate_matter_url(current_estimate_matter)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @certificates = current_estimate_matter.certificates.where(default: true).order(created_at: "DESC")
    @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
  end

  def destroy
    @certificate.destroy ? flash[:success] = "診断書を削除しました。" : flash[:alert] = "診断書を削除できませんでした。"
    redirect_to employees_estimate_matter_url(current_estimate_matter)
  end

  private
    def certificate_params
      params.require(:certificate).permit(:title, :content, :image_id)
    end

    def set_certificate
      @certificate = Certificate.find(params[:id])
    end
    
    def set_certificates
      @certificates = Certificate.all
    end
end
