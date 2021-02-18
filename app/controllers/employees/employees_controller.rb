class Employees::EmployeesController < ApplicationController
  before_action :authenticate_employee!
  
  private
  
    # -------------------------------------------------------
        # set
    # -------------------------------------------------------
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_label_colors
      @label_colors = LabelColor.order(position: :asc)
    end
    
    # schedule/sales_statusで使用
    def set_basic_schedules(day)
      @schedules = Schedule.all.order(:scheduled_start_time)
      @admin_schedules = @schedules.where(scheduled_date: day).where.not(admin_id: nil).group_by{|schedule| schedule[:admin_id]}
      @manager_schedules = @schedules.where(scheduled_date: day).where.not(manager_id: nil).group_by{|schedule| schedule[:manager_id]}
      @staff_schedules = @schedules.where(scheduled_date: day).where.not(staff_id: nil).group_by{|schedule| schedule[:staff_id]}
      @external_staff_schedules = @schedules.where(scheduled_date: day).where.not(external_staff_id: nil).group_by{|schedule| schedule[:external_staff_id]}
    end
    
    
    # -------------------------------------------------------
        # その他
    # -------------------------------------------------------
    
    # 全メンバー(配列)
    def all_member
      @members = []
      Admin.all.each do |admin|
        @members << { auth: admin.auth, id: admin.id, name: admin.name }
      end
      Manager.all.each do |manager|
        @members << { auth: manager.auth, id: manager.id, name: manager.name }
      end
      Staff.all.each do |staff|
        @members << { auth: staff.auth, id: staff.id, name: staff.name }
      end
      ExternalStaff.all.each do |external_staff|
        @members << { auth: external_staff.auth, id: external_staff.id, name: external_staff.name }
      end
      return @members
    end
  
    # 営業管理案件の担当者（配列）
    def group_for_estimete_matter
      @members = []
      Admin.all.each do |admin|
        @members << { auth: admin.auth, id: admin.id, name: admin.name }
      end
      Manager.all.each do |manager|
        @members << { auth: manager.auth, id: manager.id, name: manager.name }
      end
      @estimate_matter.staffs.each do |staff|
        @members << { auth: staff.auth, id: staff.id, name: staff.name }
      end
      @estimate_matter.external_staffs.each do |external_staff|
        @members << { auth: external_staff.auth, id: external_staff.id, name: external_staff.name }
      end
      return @members
    end
    
    
    # 担当者のパラメーター整形及びストロングパラメータにマージ
    def formatted_member_params(parameter, strong_params)
      arrey_params = parameter.split("#")
      member_authority = arrey_params[0]
      params_member_id = arrey_params[1].to_i
      case member_authority
      when "admin"
        @final_params = strong_params.merge(admin_id: params_member_id)
      when "manager"
        @final_params = strong_params.merge(manager_id: params_member_id)
      when "staff"
        @final_params = strong_params.merge(staff_id: params_member_id)
      when "external_staff"
        @final_params = strong_params.merge(external_staff_id: params_member_id)
      end
    end
    
    # -------------------------------------------------------
        # BAND
    # -------------------------------------------------------
    
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
    
    # 画像を取り込み一旦ローカルファルダに保存
    def temporary_storage_for_image(params_url, index, object)
      url = open(params_url)
      @file_name = params_url
      @file_path = Rails.root.join('public', 'temporary_storage', "#{object.id}_#{index}.jpg")
      file = open(@file_path, "wb")
      file.write(url.read)
    end
    
end