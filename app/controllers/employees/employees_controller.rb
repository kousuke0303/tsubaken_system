class Employees::EmployeesController < ApplicationController
  before_action :authenticate_employee!
  
  private
  
    # -------------------------------------------------------
        # set
    # -------------------------------------------------------
    
    def set_staff
      @staff = Staff.find(params[:staff_id])
    end
    
    def set_manager
      @manager = Manager.find(params[:manager_id])
    end
    
    def target_external_staff
      @external_staff = ExternalStaff.find(params[:external_staff_id])
    end
    
    def set_employees
      @clients = Client.all.order(created_at: :desc)
      @staffs = Staff.all
      @external_staffs = ExternalStaff.all
    end
    
    # 担当メンベーのcode_idの配列化
    def set_menbers_code_for(estimate_matter_or_matter)
      @member_name_arrey = []
      estimate_matter_or_matter.member_codes.sort_auth.each do |member_code|
        if member_code.staff.present?
          @member_name_arrey << member_code.staff.name
        elsif member_code.external_staff.present?
          @member_name_arrey << member_code.external_staff.name
        end
      end
    end
    
    def set_publishers
      @publishers = Publisher.order(position: :asc)
    end
    
    def set_attract_methods
      @attract_methods = AttractMethod.order(position: :asc)
    end

    def set_suppliers
      @suppliers = Supplier.all
    end

    def set_industries
      @industries = Industry.order(position: :asc)
    end
    
    def set_categories
      @categories = Category.order(position: :asc)
    end

    def set_plan_names
      @plan_names = PlanName.order(position: :asc)
    end
    
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_default_color_code
      @default_color_code = LabelColor.first.color_code
    end

    # 見積案件の持つ全見積をラベルカラーを取得して定義
    def set_estimates_with_plan_names_and_label_colors
      @estimates = @estimate_matter.estimates.with_plan_names_and_label_colors
    end

    # 見積案件の持つ全estimate_detailsを定義(estimatesと結合して)
    def set_estimate_details
      @estimate_details = @estimates.with_estimate_details
    end

    def set_matter_of_estimate_matter
      @matter = @estimate_matter.matter
    end

    def set_label_colors
      @label_colors = LabelColor.order(position: :asc)
    end

    def set_invoice_details
      @invoice_details = @invoice.invoice_details.order(sort_number: :asc).group_by{ |detail| detail[:category_id] }
    end

    def set_plan_name_of_invoice
      @plan_name = @invoice.plan_name
    end

    def set_color_code_of_invoice
      @color_code = @plan_name.label_color.color_code
    end
    
    def set_reports_of_matter
      @reports = @matter.reports.order(created_at: "ASC")
    end

    def set_images_of_report_cover
      @cover_img_1 = Image.find_by(id: @report_cover.img_1_id)
      @cover_img_2 = Image.find_by(id: @report_cover.img_2_id)
      @cover_img_3 = Image.find_by(id: @report_cover.img_3_id)
      @cover_img_4 = Image.find_by(id: @report_cover.img_4_id)
    end
    
    # schedule/sales_statusで使用
    def set_basic_schedules(day)
      @schedules = Schedule.origins
      target_schedules = @schedules.joins(:member_code).where(scheduled_date: day)
      @schedules_of_day = target_schedules.sort_by{|schedule| schedule.scheduled_start_time.to_s(:time)}
                                          .group_by{|schedule| schedule[:member_code_id]}
                                          .sort_by{|key, value| @member_codes.ids.index(key)}.to_h
    
    end
    
    def set_matter
      @matter = Matter.find(params[:matter_id])
    end

    def set_matter_by_matter_id
      @matter = Matter.find(params[:matter_id])
    end
    
    
    # -------------------------------------------------------
        # その他
    # -------------------------------------------------------
    
    # 全MEMBER_CORD
    def all_member_code
      @member_codes = MemberCode.all_member_code_of_avaliable
    end
    
    
    def all_staff_and_external_staff_code
      @all_staff_codes = MemberCode.joins(:staff).where(staffs: {avaliable: true})
                                   .select('member_codes.*, staffs.name AS staff_name')
      @all_external_staff_codes = MemberCode.joins(:external_staff).where(external_staffs: {avaliable: true})
                                            .select('member_codes.*, external_staffs.name AS external_staff_name')
    end
    
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
    def group_for(estimate_matter_or_matter)
      @group = []
      @group << Admin.first.member_code.id
      
      Manager.where(avaliable: true).each do |manager|
        @group << manager.member_code.id
      end
      
      estimate_matter_or_matter.member_codes.sort_auth.each do |member_code|
        @group << member_code.id
      end
      return @group
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
    
    # -------------------------------------------------------
        # BEFORE_ACTION 条件
    # -------------------------------------------------------
    
    def object_is_staff?
      if params[:staff_id]
        true
      else
        false
      end
    end
    
    def object_is_manager?
      if params[:manager_id]
        true
      else
        false
      end
    end
    
    def object_is_external_staff?
      if params[:external_staff_id]
        true
      else
        false
      end
    end
    
end