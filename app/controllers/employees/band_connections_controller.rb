class Employees::BandConnectionsController < Employees::EmployeesController
  before_action :get_band, only: :index

  def index
    unless current_estimate_matter.band_connection.present?
      @band = current_estimate_matter.build_band_connection
      @type = "new"
    else
      @band = current_estimate_matter.band_connection
      @type ="edit"
    end
  end
  
  def connect
    if params[:type] == "new"
      @band = current_estimate_matter.create_band_connection(band_key: params[:band_key], 
                                                      band_name: params[:band_name],
                                                      band_icon: params[:band_cover])
    else
      @band = current_estimate_matter.band_connection
      @band.update_attributes(band_key: params[:band_key], 
                              band_name: params[:band_name],
                              band_icon: params[:band_cover])
    end
  end
  
  def get_album
    @band_key = BandConnection.find(params[:id]).band_key
    search_image(@band_key)
    @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
  end
  
  private
    def get_band
      submit_params = URI.encode_www_form({ access_token: "ZQAAAUd9_L9isVXMSdRleMreMjkmBnAltSU__WC3Y-eeseqhAdzzJklawBFw2iF_ffgTFMqG_-fv1dOB3Jzd9sqCZEHhiWJ0vBlRA3xhfthxneay"})
      uri = URI.parse("https://openapi.band.us/v2.1/bands?#{submit_params}")
    
      api_response = Net::HTTP.get(uri)
      result = JSON.parse(api_response)
      @bands_hash = result["result_data"]["bands"]
    
    # {"result_code"=>1, "result_data"=>{"bands"=>[{"name"=>"TEST1", "cover"=>"https://coresos-phinf.pstatic.net/a/2ih0ci/c_f6hUd018adm7mwzpvy4ulla_uxw4v2.jpg", "member_count"=>1, "band_key"=>"AAABszO1LYjWg-X6anf2MF77"}, {"name"=>"TEST2", "cover"=>"https://coresos-phinf.pstatic.net/a/2ih056/d_06hUd018adm8osncr0bs9ap_8xhqph.jpg", "member_count"=>1, "band_key"=>"AADuGicBbeCnwSxRTMrfmAnl"}]}}
    end
    
    def search_image(band_key)
      submit_params = URI.encode_www_form({ access_token: "ZQAAAUd9_L9isVXMSdRleMreMjkmBnAltSU__WC3Y-eeseqhAdzzJklawBFw2iF_ffgTFMqG_-fv1dOB3Jzd9sqCZEHhiWJ0vBlRA3xhfthxneay",
                                            band_key: band_key,
                                            locale: "ja_JP"})
      uri = URI.parse("https://openapi.band.us/v2/band/posts?#{submit_params}")
      api_response = Net::HTTP.get(uri)
      result = JSON.parse(api_response)
      @photo_arrey = []
      result["result_data"]["items"].each do |item|
        if item["photos"] != []
          photo_info = Hash.new()
          photo_info.store("author", item["author"]["name"])
          photo_info.store("content", item["content"])
          photo_info.store("created_at", Time.at(item["created_at"] / 1000, in: "+09:00"))
          photo_url_arrey = []
          item["photos"].each do |photo|
            photo_url_arrey << photo["url"]
          end
          photo_info.store("photo", photo_url_arrey)
          @photo_arrey << photo_info
        end
      end
      return @photo_arrey
    end
      

end
