module Employees::BandConnectionsHelper
  
  # 取り込み済み画像か否か
  def previously_saved_image?(array, image_url)
    array.present? && array.select{ |array| array["default_file_path"] == image_url }.present?
  end
end
