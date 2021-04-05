class Admins::StatisticsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    ###### 共通変数定義 ######
    est_matters = EstimateMatter.all
    matters = Matter.all
    ## 月別
    @first_day = Date.current.beginning_of_month
    @last_day = Date.current.end_of_month
    @est_matters_for_span = est_matters.where(created_at: @first_day..@last_day)
    @matters_for_span = matters.where(created_at: @first_day..@last_day)
    ## 年間
    @day_for_one_years_ago = (Date.current - 12.month).beginning_of_month
    
    ###### 年間：月別統計 ########
    statics_for_month
    
    ###### 営業詳細分析 ########
    date_for_estimate_matters_count
    date_for_estimate_matters_area_count
    date_for_estimate_matters_attract_count
  end
  
  def change_span
    if params[:start_date].present?
      @first_day = params[:start_date].to_date
    else
      @first_day = Date.current
    end
    if params[:end_date].present?
      @last_day = params[:end_date].to_date
    else
      @last_day = Date.current
    end
    @est_matters_for_span = EstimateMatter.where(created_at: @first_day..@last_day)
    date_for_estimate_matters_count
    date_for_estimate_matters_area_count
    date_for_estimate_matters_attract_count
    respond_to do |format|
      format.js
    end
  end
  
  private
    def statics_for_month
      # 営業案件数データ
      @hash_est_count_for_month = Hash.new()
      # 売上データ
      @hash_total_price_for_month = Hash.new()
      
      13.times do |n|
        first_day = @day_for_one_years_ago + n.month
        last_day = first_day.end_of_month
        estimate_matters = EstimateMatter.where(created_at: first_day..last_day)
        matters = Matter.where(created_at: first_day..last_day)
        key = "#{first_day.year}/#{first_day.month}"
        if estimate_matters.present?
          value = estimate_matters.count
          @hash_est_count_for_month.store(key, value)
        else
          value = 0
          @hash_est_count_for_month.store(key, value)
        end
        if matters.present?
          value = matters.joins(:invoice).sum('invoices.total_price')
          
          @hash_total_price_for_month.store(key, value)
        else
          value = 0
          @hash_total_price_for_month.store(key, value)
        end
      end        
    end
  
  
    #### 営業案件関連DATE ########
    def date_for_estimate_matters_count
      # 1.グラフ用配列型を作成（中身はHash）
      @est_matter_date_for_graph = []
      contract_hash = Hash.new()
      contract_hash[:name] = "成約数"
      contract_hash[:data] = []
      uncontract_hash = Hash.new()
      uncontract_hash[:name] = "未成約数"
      uncontract_hash[:data] = []
      @est_matter_date_for_graph << contract_hash
      @est_matter_date_for_graph << uncontract_hash
      
      # 2.表示用データの型作成
      @est_matter_date_for_table = []
      
      #### 3.包括的変数 ####
      #　ステータスが契約の営業案件
      est_matter_for_contracts = @est_matters_for_span.joins(:sales_statuses).where(sales_statuses: {status: 6})
      #  
      matter_join_price = @est_matters_for_span.joins(matter: :invoice)
      
      # 4.各配列にデータを格納(staff関連)
      Staff.all.each do |staff|
        # 変数取得
        number_of_contracts_of_staff = est_matter_for_contracts.joins(:member_codes).where(member_codes: { staff_id: staff.id }).count
        est_number = staff.estimate_matters.where(created_at: @first_day..@last_day).count
        total_price_of_staff = matter_join_price.joins(:member_codes).where( member_codes: { staff_id: staff.id }).sum('invoices.total_price')
        # グラフ用
        contract_hash[:data] << [staff.name, number_of_contracts_of_staff]
        uncontract_hash[:data] << [staff.name, est_number - number_of_contracts_of_staff]
        # 表示用
        tr_hash = Hash.new()
        tr_hash[:name] = staff.name
        tr_hash[:est_number] = est_number
        tr_hash[:contract] = number_of_contracts_of_staff
        tr_hash[:price] = total_price_of_staff
        @est_matter_date_for_table << tr_hash
      end
      
      # 5.staffが関係していない営業案件
        number_of_contracts_except_staff = est_matter_for_contracts.joins(:member_codes).where(member_codes: { staff_id: nil }).count
        est_number_except_stafff = est_matter_for_contracts.joins(:member_codes).where(member_codes: {staff_id: nil}).count
        total_price_except_staff = matter_join_price.joins(:member_codes).where(member_codes: { staff: nil }).sum('invoices.total_price')
        # グラフ用
        contract_hash[:data] << ["その他", number_of_contracts_except_staff]
        uncontract_hash[:data] << ["その他", est_number_except_stafff - number_of_contracts_except_staff]
        # 表示用
        tr_hash = Hash.new()
        tr_hash[:name] = "その他"
        tr_hash[:est_number] = est_number_except_stafff
        tr_hash[:contract] = number_of_contracts_except_staff
        tr_hash[:price] = total_price_except_staff
        @est_matter_date_for_table << tr_hash
    end
    
    ###### 営業エリア分析 ##########
    def date_for_estimate_matters_area_count
      # 営業関係
      est_area_date = @est_matters_for_span.group(:address_city).count
      est_area_date_arrey = est_area_date.to_a
      est_area_date_arrey.each do |arrey|
        adress_city_divide(arrey[0])
        arrey[0] = @result
      end
      @area_date_of_est = est_area_date_arrey.each_with_object(Hash.new(0)){|(k, v), h| h[k] += v }
      # 表示用
      price_for_area_date = @est_matters_for_span.joins(matter: :estimate).group(:address_city).sum('total_price')
      price_arrey_for_area_date = price_for_area_date.to_a
      price_arrey_for_area_date.each do |arrey|
        adress_city_divide(arrey[0])
        arrey[0] = @result
      end
      @price_date_for_est_area = price_arrey_for_area_date.each_with_object(Hash.new(0)){|(k, v), h| h[k] += v }
      @area_date_of_est_for_table = @area_date_of_est.merge(@price_date_for_est_area){|key, h1v, h2v| [h1v, h2v]}
      @area_date_of_est_for_table.each do |key, value|
        number_of_contract = @est_matters_for_span.joins(:sales_statuses).where("address_city LIKE ?", "%#{key}%").where(sales_statuses: { status: 6 }).count
        area_date = [value[0], number_of_contract, value[1]]
        @area_date_of_est_for_table.store(key, area_date)
      end
    end
    
    def adress_city_divide(adress_city)
      # 市区町村を含む例外を配列にする
      special_city = ["市川市", "市原市", "野々市市", "四日市市", "廿日市市", 
                      "町田市", "十日町市", "大町市", "村山市", "田村市", "東村山市",
                      "武蔵村山市", "羽村市", "村上市", "大村市", "余市町", "市貝町",
                      "上市町", "市川三郷町", "市川町", "下市町", "大町町", "村田町",
                      "玉村町", "中村区"]
      # 通常の処理と例外の場合わけ
      special_city.each do |sp_city|
        if adress_city.include?(sp_city)
          @result = sp_city
        else
          divide_city = adress_city.split("市" || "区" || "町" || "村")
          @result = divide_city[0]
        end
      end
    end
    
    ##### 広告別営業件数 #########
    
    def date_for_estimate_matters_attract_count
      # graph用型
      # {"タウンページ"=>1, "チラシ広告"=>1, "未設定"=>0}
      # 営業件数
      @graph_date_for_attract_count = Hash.new()
      
      AttractMethod.includes(:estimate_matters).each do |attract|
        if EstimateMatter.where(created_at: @first_day..@last_day, attract_method_id: attract.id).present?
          value = EstimateMatter.where(created_at: @first_day..@last_day, attract_method_id: attract.id).count
        else
          value = 0
        end
        @graph_date_for_attract_count.store(attract.name, value)
      end
      
      # 広告未設定の数
      date_for_no_attract_count = @est_matters_for_span.where(attract_method_id: nil).count
      # 未設定数追加
      @graph_date_for_attract_count.store("未設定", date_for_no_attract_count)
      
      ### 表示用 ###
      # 表示用型
      # {"name"=>[案件数, 成約数, 売上], "チラシ広告"=>[1, 0, 10000], "未設定"=>[0,0,0]}
      @table_date_for_attract_count = Hash.new()
      
      # 成約数
      contract_count_for_attract_method = AttractMethod.left_joins(estimate_matters: :sales_statuses)
                                             .where(estimate_matters: { created_at: @first_day..@last_day})
                                             .where(estimate_matters: { sales_statuses: { status: 6}})
                                             .group(:name).count
      # 売上高
      price_for_attract_method = AttractMethod.left_joins(estimate_matters: {matter: :invoice})
                                 .where(estimate_matters: { created_at: @first_day..@last_day})
                                 .where.not(estimate_matters: {matters: {estimate_matter_id: nil}})
                                 .group(:name).sum('invoices.total_price')
      # 未設定成約数
      contract_for_no_attract = Matter.joins(:estimate_matter)
                                      .where(estimate_matters: {created_at: @first_day..@last_day, attract_method_id: nil})
      # 未設定売上高
      price_for_no_attract = @est_matters_for_span.joins(matter: :invoice).where(attract_method_id: nil).sum('invoices.total_price')
      
      @graph_date_for_attract_count.each do |key, est_count|
        attract_date = []
        attract_date << est_count
        if key == "未設定"
          if contract_for_no_attract.present?
            attract_date << contract_for_no_attract
          else
            attract_date << 0
          end
          if price_for_no_attract.present?
            attract_date << price_for_no_attract
          else
            attract_date << 0
          end
        else
          if contract_count_for_attract_method[key].present?
            attract_date << contract_count_for_attract_method[key]
          else
            attract_date << 0
          end
          if price_for_attract_method[key].present?
            attract_date << price_for_attract_method[key]
          else
            attract_date << 0
          end
        end
        @table_date_for_attract_count.store(key, attract_date)
      end
    end
end
