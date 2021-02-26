class Employees::BandConnectionsController < Employees::EmployeesController
  before_action :get_band, only: :index

  def index
    if current_estimate_matter
      unless current_estimate_matter.band_connection.present?
        @band = current_estimate_matter.build_band_connection
        @type = "new_for_estimate_matter"
      else
        @band = current_estimate_matter.band_connection
        @type = "edit_for_estimate_matter"
      end
    end
    if current_matter
      unless current_matter.band_connection.present?
        @band = current_matter.build_band_connection
        @type = "new_for_matter"
      else
        @band = current_matter.band_connection
        @type = "edit_for_matter"
      end
    end
  end
  
  def reload
    if current_estimate_matter
      @images = current_estimate_matter.images
      @submit_type = "est_matter_reload"
      @estimate_matter = current_estimate_matter
    end
  end
  
  def connect
    if params[:type] == "new_for_estimate_matter"
      @band = current_estimate_matter.create_band_connection(band_key: params[:band_key], 
                                                      band_name: params[:band_name],
                                                      band_icon: params[:band_cover])
    elsif params[:type] == "edit_for_estimate_matter"
      @band = current_estimate_matter.band_connection
      @band.update_attributes(band_key: params[:band_key], 
                              band_name: params[:band_name],
                              band_icon: params[:band_cover])
    elsif params[:type] == "new_for_matter"
      @band = current_matter.create_band_connection(band_key: params[:band_key], 
                                                    band_name: params[:band_name],
                                                    band_icon: params[:band_cover])
    elsif params[:type] == "edit_for_matter"
      @band = current_matter.band_connection
      @band.update_attributes(band_key: params[:band_key], 
                              band_name: params[:band_name],
                              band_icon: params[:band_cover])
    end
  end
  
  def destroy
    @band = BandConnection.find(params[:id])
    @band.destroy
    current_matter if current_matter
    current_estimate_matter if current_estimate_matter
  end
  
  def get_album
    @band_key = BandConnection.find(params[:id]).band_key
    search_image(@band_key)
    if current_estimate_matter
      @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.image.attached? }
    elsif current_matter
      @images = current_matter.images.order(shooted_on: "DESC").select { |image| image.image.attached? }
    end
  end
  
  private
    def get_band
      submit_params = URI.encode_www_form({ access_token: "ZQAAAUd9_L9isVXMSdRleMreMjkmBnAltSU__WC3Y-eeseqhAdzzJklawBFw2iF_ffgTFMqG_-fv1dOB3Jzd9sqCZEHhiWJ0vBlRA3xhfthxneay"})
      uri = URI.parse("https://openapi.band.us/v2.1/bands?#{submit_params}")
    
      api_response = Net::HTTP.get(uri)
      result = JSON.parse(api_response)
      @bands_hash = result["result_data"]["bands"].reverse
    
    # {"result_code"=>1, "result_data"=>{"bands"=>[{"name"=>"TEST1", "cover"=>"https://coresos-phinf.pstatic.net/a/2ih0ci/c_f6hUd018adm7mwzpvy4ulla_uxw4v2.jpg", "member_count"=>1, "band_key"=>"AAABszO1LYjWg-X6anf2MF77"}, {"name"=>"TEST2", "cover"=>"https://coresos-phinf.pstatic.net/a/2ih056/d_06hUd018adm8osncr0bs9ap_8xhqph.jpg", "member_count"=>1, "band_key"=>"AADuGicBbeCnwSxRTMrfmAnl"}]}}
    end
end
