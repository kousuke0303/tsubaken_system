class Employees::EstimateMatters::CertificatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_certificate, only: [:edit, :update, :destroy]

  def new
    @certificate = Certificate.new
    @certificates = Certificate.where(default: true)
    @image = Image.find(params[:image_id])
  end

  def create
    @certificate = @estimate_matter.certificates.new(certificate_params)
    @certificate.save ? @responce = "success" : @responce = "false"
    set_images
    @certificates = @estimate_matter.certificates.order(created_at: "DESC")
    respond_to do |format|
      format.js
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
    
    def set_images
      @images = @estimate_matter.images
    end
end
