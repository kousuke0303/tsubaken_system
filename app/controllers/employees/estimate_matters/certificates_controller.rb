class Employees::EstimateMatters::CertificatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_certificate, only: [:edit, :update, :destroy]
  
  require "fileutils"
  
  def sort
    from = params[:from].to_i + 1
    certificate = @estimate_matter.certificates.find_by(position: from)
    certificate.insert_at(params[:to].to_i + 1)
    @certificates = @estimate_matter.certificates.order(position: :asc)
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
  end

  def edit
    @image = @certificate.image
  end

  def update
    @certificate.update(certificate_params) ? @responce = "success" : @responce = "false"
    set_certificates
  end
  
  def download
    @certificates = @estimate_matter.certificates.where(default: false).order(created_at: "DESC")
    @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
    @certificates.each do |certificate|
      @images.each do |image|
        @files = certificate.image.images[0].download
      end
      if send_data(@files, filename: certificate.image.images[0].filename.to_s, # ファイル名の取得
                  type: certificate.image.images[0].content_type) # content_typeの取得
      end
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
