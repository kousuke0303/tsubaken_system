class Employees::EstimateMatters::CertificatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_certificate, only: [:edit, :update, :destroy]

  def new
    @certificate = Certificate.new
    @certificates = Certificate.where(default: true)
    @images = @estimate_matter.images.select { |image| image.images.attached? }
  end

  def create
    @certificate = @estimate_matter.certificates.new(certificate_params)
    if @certificate.save
      flash[:success] = "診断書を作成しました。"
      redirect_to employees_estimate_matter_images_url(@estimate_matter)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    @image = @certificate.image
  end

  def update
    @certificate.update(certificate_params) ? @responce = "success" : @responce = "false"
    set_certificates
    respond_to do |format|
      format.js
    end
  end

  def index
    @certificates = @estimate_matter.certificates.where(default: false).order(created_at: "DESC")
    @images = @estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
  end

  def destroy
    @certificate.destroy
    set_certificates
    respond_to do |format|
      format.js
    end
  end

  private
    def certificate_params
      params.require(:certificate).permit(:title, :content, :image_id)
    end

    def set_certificate
      @certificate = Certificate.find(params[:id])
    end
    
    def set_certificates
      @certificates = @estimate_matter.certificates
    end
end
