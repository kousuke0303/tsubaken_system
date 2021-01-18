class Admins::StatisticsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    # 月別営業カウント
    est_count_for_month = EstimateMatter.group("YEAR(created_at)").group("MONTH(created_at)").count
    @hash_est_count_for_month = Hash.new() 
    est_count_for_month.each do |key, value|
      new_key = "#{key[0]}/#{key[1]}"
      @hash_est_count_for_month.store(new_key, value)
    end
      
    # 営業詳細分析
    @first_day = Date.today.beginning_of_month
    @last_day = Date.today
    @est_matters = EstimateMatter.where(created_at: @first_day..@last_day)
    date_for_estimate_matters_count
    date_for_estimate_matters_area_count
    date_for_estimate_matters_attract_count
  end
  
  def change_span
    if params[:start_date].present?
      @first_day = params[:start_date].to_date
    else
      @first_day = Date.today
    end
    if params[:end_date].present?
      @last_day = params[:end_date].to_date
    else
      @last_day = Date.today
    end
    @est_matters = EstimateMatter.where(created_at: @first_day..@last_day)
    date_for_estimate_matters_count
    date_for_estimate_matters_area_count
    date_for_estimate_matters_attract_count
    respond_to do |format|
      format.js
    end
  end
  
  private
    # 営業案件関連DATE
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
        #成約案件
        contracts = @est_matters.left_joins(:estimate_matter_staffs, :sales_statuses).where(sales_statuses: {status: 6})
      
      # 4.各配列にデータを格納(staff関連)
      Staff.all.each do |staff|
        # 変数取得
        number_of_contracts_of_staff = contracts.where(estimate_matter_staffs: { staff_id: staff.id }).count
        est_number = staff.estimate_matters.where(created_at: @first_day..@last_day).count
        # グラフ用
        contract_hash[:data] << [staff.name, number_of_contracts_of_staff]
        uncontract_hash[:data] << [staff.name, est_number - number_of_contracts_of_staff]
        # 表示用
        tr_hash = Hash.new()
        tr_hash[:name] = staff.name
        tr_hash[:est_number] = est_number
        tr_hash[:contract] = number_of_contracts_of_staff
        @est_matter_date_for_table << tr_hash
      end
      
      # 5.staffが関係していない営業案件
        number_of_contracts_of_nonstaff = contracts.where(estimate_matter_staffs: { estimate_matter_id: nil }).count
        est_number_of_nonstaff = @est_matters.left_joins(:estimate_matter_staffs).where(estimate_matter_staffs: {estimate_matter_id: nil}).count
        # グラフ用
        contract_hash[:data] << ["その他", number_of_contracts_of_nonstaff]
        uncontract_hash[:data] << ["その他", est_number_of_nonstaff - number_of_contracts_of_nonstaff]
        # 表示用
        tr_hash = Hash.new()
        tr_hash[:name] = "その他"
        tr_hash[:est_number] = est_number_of_nonstaff
        tr_hash[:contract] = number_of_contracts_of_nonstaff
        @est_matter_date_for_table << tr_hash
    end
    
    # 営業エリア分析
    def date_for_estimate_matters_area_count
      basic_date = @est_matters.group(:address_city).count
      basic_date_arrey = basic_date.to_a
      basic_date_arrey.each do |arrey|
        adress_city_divide(arrey[0])
        arrey[0] = @result
      end
      @area_date_of_est = basic_date_arrey.each_with_object(Hash.new(0)){|(k, v), h| h[k] += v }
      # 表示用
      @area_date_of_est_for_table = @area_date_of_est
      @area_date_of_est_for_table.each do |key, value|
        number_of_contract = @est_matters.joins(:sales_statuses).where("address_city LIKE ?", "%#{key}%").where(sales_statuses: { status: 6 }).count
        area_date = [value, number_of_contract]
        @area_date_of_est_for_table.store(key, area_date)
      end
    end
    
    def adress_city_divide(adress_city)
      # 市区町村を含む例外を配列にする
      special_city = ["市川市", "市原市", "野々市市", "四日市市", "廿日市市", 
                      "町田市", "十日町市", "大町市", "村山市", "田村市", "東村山市",
                      "武蔵村山市", "羽村市", "村上市", "大村市"]
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
    
    # 広告別営業件数
    def date_for_estimate_matters_attract_count
      @graph_date_for_attract_count = AttractMethod.left_joins(:estimate_matters).where(estimate_matters: { created_at: @first_day..@last_day}).group(:name).count
      basic_date_for_attract_count = AttractMethod.joins(estimate_matters: :sales_statuses).where(sales_statuses: { status: 6}).group(:name).count
      @table_date_for_attract_count = @graph_date_for_attract_count.merge(basic_date_for_attract_count) {|key, oldval, newval| [oldval, newval] }
    end
end
