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
    day_for_one_years_ago = (Date.current - 12.month).beginning_of_month
    est_matters_for_one_year = est_matters.where(created_at: day_for_one_years_ago..@last_day)
    matter_for_one_year = matters.where(created_at: day_for_one_years_ago..@last_day)
    
    ###### 月別営業カウント ########
    est_count_for_month = est_matters_for_one_year.group("YEAR(created_at)").group("MONTH(created_at)").count
    @hash_est_count_for_month = Hash.new() 
    est_count_for_month.each do |key, value|
      new_key = "#{key[0]}/#{key[1]}"
      @hash_est_count_for_month.store(new_key, value)
    end
    
    ###### 月別売上 #########
    total_price_for_matter = matter_for_one_year.joins(:estimate)
                                          .group("YEAR(matters.created_at)").group("MONTH(matters.created_at)")
                                          .sum('estimates.total_price')
    @hash_total_price_for_month = Hash.new() 
    total_price_for_matter.each do |key, value|
      new_key = "#{key[0]}/#{key[1]}"
      @hash_total_price_for_month.store(new_key, value)
    end 
    
    
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
      
      # 3.包括的変数
      est_join_contracts = @est_matters_for_span.left_joins(:estimate_matter_staffs, :sales_statuses).where(sales_statuses: {status: 6})
      matter_join_price = @est_matters_for_span.left_joins(estimates: {matter: :matter_staffs})
      
      # 4.各配列にデータを格納(staff関連)
      Staff.all.each do |staff|
        # 変数取得
        number_of_contracts_of_staff = est_join_contracts.where(estimate_matter_staffs: { staff_id: staff.id }).count
        est_number = staff.estimate_matters.where(created_at: @first_day..@last_day).count
        total_price_of_staff = matter_join_price.where(estimates: {matters: { matter_staffs: { staff_id: staff.id }}}).sum('estimates.total_price')
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
        number_of_contracts_of_nonstaff = est_join_contracts.where(estimate_matter_staffs: { estimate_matter_id: nil }).count
        est_number_of_nonstaff = @est_matters_for_span.left_joins(:estimate_matter_staffs).where(estimate_matter_staffs: {estimate_matter_id: nil}).count
        total_price_of_nonstaff = matter_join_price.where(matter_staffs: { matter_id: nil }).sum('estimates.total_price')
        # グラフ用
        contract_hash[:data] << ["その他", number_of_contracts_of_nonstaff]
        uncontract_hash[:data] << ["その他", est_number_of_nonstaff - number_of_contracts_of_nonstaff]
        # 表示用
        tr_hash = Hash.new()
        tr_hash[:name] = "その他"
        tr_hash[:est_number] = est_number_of_nonstaff
        tr_hash[:contract] = number_of_contracts_of_nonstaff
        tr_hash[:price] = total_price_of_nonstaff
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
      # 営業件数
      @graph_date_for_attract_count = AttractMethod.left_joins(:estimate_matters).where(estimate_matters: { created_at: @first_day..@last_day}).group(:name).count
      # 広告未設定の数
      date_for_no_attract_count = @est_matters_for_span.where(attract_method_id: nil).count
      # 未設定数追加
      @graph_date_for_attract_count.store("未設定", date_for_no_attract_count)
      
      ### 表示用 ###
      # 成約数
      date_for_attract_count = AttractMethod.left_joins(estimate_matters: :sales_statuses).where(estimate_matters: { created_at: @first_day..@last_day}).where(estimate_matters: { sales_statuses: { status: 6}}).group(:name).count
      # 売上高
      date_for_price = AttractMethod.left_joins(estimate_matters: {matter: :estimate}).where(estimate_matters: { created_at: @first_day..@last_day}).where.not(estimate_matters: {matters: {estimate_matter_id: nil}})
                                    .group(:name).sum('estimates.total_price')
      # 未設定売上高
      non_date_for_price = @est_matters_for_span.joins(matter: :estimate).where(matters: {estimate_matter_id: nil}).where(attract_method_id: nil).sum('estimates.total_price')
      # 未設定数追加
      date_for_price.store("未設定", non_date_for_price)
      # 整形　merageだとnilの時配列にならない
      @table_date_for_attract_count = Hash.new()
      @graph_date_for_attract_count.each do |key, val|
        if date_for_attract_count.keys.include?(key)
          date = [val, date_for_attract_count[key]]
        else
          date =[val, 0]
        end
        @table_date_for_attract_count.store(key, date)
      end
      @table_date_for_attract_count.merge(date_for_price){|k, v1, v2| v1 << v2}
    end
end
