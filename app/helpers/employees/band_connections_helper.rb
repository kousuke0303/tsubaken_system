module Employees::BandConnectionsHelper
  
  # 取り込み済み画像か否か
  def previously_saved_image?(arrey, image_url)
    if arrey.present? && arrey.select{|arrey| arrey["default_file_path"] == image_url}.present?
      return true
    else
      return false
    end
  end
end
