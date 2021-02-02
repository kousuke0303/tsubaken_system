class Employees::EstimateMatters::CertificatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_certificate, only: [:edit, :update, :destroy]
  
  def sort
    from = params[:from].to_i + 1
    certificate = @estimate_matter.certificates.find_by(position: from)
    certificate.insert_at(params[:to].to_i + 1)
    @certificates = @estimate_matter.certificates.order(position: :asc)
    respond_to do |format|
      format.js
    end
  end

  def new
    @certificate = Certificate.new
    @certificates = Certificate.where(default: true)
    @image = Image.find(params[:image_id])
  end

  def create
    @certificate = @estimate_matter.certificates.new(certificate_params)
    @certificate.save ? @responce = "success" : @responce = "false"
    set_images
    set_certificates
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
    
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="診断書一覧"'+ Time.zone.now.strftime('%Y%m%d') + '.xlsx'
      end
    end
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
      @certificates = @estimate_matter.certificates.order(created_at: "DESC")
    end
    
    def set_images
      @images = @estimate_matter.images
    end
end
