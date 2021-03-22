class Employees::Matters::InvoicesController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_categories, only: :edit
  before_action :set_plan_names, only: [:show, :edit]
  before_action :set_default_color_code, only: :edit
  before_action :set_matter_by_matter_id
  before_action :set_invoice
  before_action :refactor_params_category_ids, only: :update

  def show
    @estimate_matter = @matter.estimate_matter
    @color_code = @invoice.plan_name.label_color.color_code
    set_invoice_details
  end

  def edit
    @color_code = @invoice.plan_name.label_color.color_code
    # カテゴリ登録がすでにある場合
    if @invoice.invoice_details.present?
      @invoice_details = @invoice.invoice_details.order(:sort_number).group(:category_id)
      @type = "category_presence"
    # カテゴリがない場合
    else
      @type = "no_category"
    end
  end

  def update
    if @invoice.update(invoice_params)
      if @after_category_array.present?
        comparison_for_category # 差分比較
        # ①パターン：カテゴリ初登録及びカテゴリ増加        
        register_categories(@add_categories) if @add_category_array != "nil"        
        # ②パターン：カテゴリ削除
        decrease_category(@delete_categories) if @delete_category_array != "nil"              
        # 順番変更
        change_category_order
      end
      @response = "success"
      @invoice.calc_total_price
      set_plan_name_of_invoice
      set_color_code_of_invoice
      set_invoice_details
    end
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.require(:invoice).permit(:plan_name_id, :discount)
    end

    # パラメーター整形
    def refactor_params_category_ids
      params_categories = params[:invoice][:category_ids].split(",").map(&:to_i)
      @after_category_array = []
      params_categories.each do |params_categopry|
        @after_category_array << params_categopry unless params_categopry == 0
      end
    end

    # 差分調査
    def comparison_for_category
      before_category_array = @invoice.invoice_details.pluck(:category_id)
      # カテゴリが増えている場合
      (@after_category_array - before_category_array) == [nil] || @after_category_array == before_category_array ?
      @add_category_array = "nil" : @add_categories = @after_category_array - before_category_array      
      # カテゴリが減っている場合
      (before_category_array - @after_category_array) == [nil] || before_category_array == @after_category_array ?
      @delete_category_array = "nil" : @delete_categories = before_category_array - @after_category_array
    end

    # カテゴリ登録
    def register_categories(category_id_array)
      before_detail_count = @invoice.invoice_details.count
      category_id_array.each.with_index(1) do |category_id, index|
        default_category = Category.find(category_id)
        @invoice.invoice_details.create!(category_name: default_category.name,
                                                           category_id: default_category.id,
                                                           sort_number: before_detail_count + index)
      end
    end

    # カテゴリ減少
    def decrease_category(category_id_array)
      category_id_array.each do |category_id|
        @invoice.invoice_details.where(category_id: category_id).destroy_all
      end
    end

    # 順番変更
    def change_category_order
      details = @invoice.invoice_details.sort_by{|detail| @after_category_array.index(detail.category_id)}
      details.each.with_index(1) do |detail, i|
        detail.update(sort_number: i * 100)
      end
    end
end
