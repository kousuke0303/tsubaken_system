class Employees::EstimateMatters::EstimatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_estimate, only: [:show, :edit, :update, :copy, :destroy]
  before_action :refactor_params_category_ids, only: [:create, :update]
  
  def show
    @estimate_details = @estimate.estimate_details.order(:sort_number).group_by{ |detail| detail[:category_id] }
    respond_to do |format|
      format.html { redirect_to action: :pdf, format: :pdf, debug: true }
      format.pdf do
        render pdf: "file_name",
               encoding: "utf-8",
               page_size: "A4",
               layout: "pdf/estimates.html.erb",
               template: "/employees/estimate_matters/estimates/show.html.erb",
               show_as_html: params[:debug].present?,
               send_data pdf, filename: "estimate.pdf"
      end
    end
  end

  def new
    @estimate = @estimate_matter.estimates.new
    @categories = Category.order(position: :asc)
    @plan_names = PlanName.order(position: :asc)
  end

  # デフォルトのプラン名に合わせて、ラベルカラーをajaxで変更
  def change_label_color
    id = params[:id].to_i
    plan_name = PlanName.find(id)
    @sample_color = plan_name.label_color.color_code
  end

  def create
    @estimate = @estimate_matter.estimates.new(estimate_params)
    if @estimate.save
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if @after_category_arrey.present?
        params_categories = params[:estimate][:category_ids].split(",").map(&:to_i)
        params_categories.each.with_index(1) do |params_id, i|
          default_category = Category.find(params_id)
          @estimate.estimate_details.create!(category_name: default_category.name, category_id: params_id, sort_number: i * 100)
        end
      end
      @response = "success"
      @estimates = @estimate_matter.estimates
    end
  end

  def edit
    @categories = Category.order(position: :asc)
    @plan_names = PlanName.order(position: :asc)
    @default_color = LabelColor.first.color_code
    # カテゴリ登録がすでにある場合
    if @estimate.estimate_details.present?
      estimate_details = @estimate.estimate_details.order(:sort_number)
      @estimate_details = estimate_details.group(:category_id)
      @type = "category_presence"
    # カテゴリがない場合
    else
      @type = "no_category"
    end
  end

  def update
    if @estimate.update(estimate_params)
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if @after_category_arrey.present?
        # 差分比較
        comparison_for_category
        
        # ①パターン：カテゴリ初登録及びカテゴリ増加
        if @add_categories.present?
          register_categories(@add_categories)
        end
        
        # ②パターン：カテゴリ削除
        if @delete_categories.present?
          decrease_category(@delete_categories)
        end
        
        # 順番変更
        change_category_order
      end
      @response = "success"
      @estimates = @estimate_matter.estimates
    end
  end

  def destroy
    @estimate.destroy
    @estimates = @estimate_matter.estimates
  end

  # 見積複製アクション
  def copy
    new_estimate = @estimate.deep_dup
    new_estimate.title = "C:" + new_estimate.title
    new_estimate.save
    
    @estimate.estimate_details.each do |detail|
      new_detail = detail.deep_dup
      new_detail.estimate_id = new_estimate.id
      new_detail.save
    end
    @estimates = @estimate_matter.estimates
  end

  private
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    def estimate_params
      params.require(:estimate).permit(:title, :plan_name_id, :discount)
    end
    
    # パラメーター整形
    def refactor_params_category_ids
      params_categories = params[:estimate][:category_ids].split(",").map(&:to_i)
      # 空欄を除く
      @after_category_arrey = []
      params_categories.each do |params_categopry|
        unless params_categopry == 0
          @after_category_arrey << params_categopry
        end
      end
    end
    
    # 差分調査
    def comparison_for_category
      before_category_arrey = @estimate.estimate_details.pluck(:category_id)
      # カテゴリが増えている場合
      if (@after_category_arrey - before_category_arrey).present?
        @add_categories = @after_category_arrey - before_category_arrey
      end
      # カテゴリが減っている場合
      if (before_category_arrey - @after_category_arrey).present?
        @delete_categories = before_category_arrey - @after_category_arrey
      end
    end
    
    # カテゴリ登録
    def register_categories(category_id_arrey)
      before_detail_count = @estimate.estimate_details.count
      category_id_arrey.each.with_index(1) do |category_id, index|
        default_category = Category.find(category_id)
        @estimate.estimate_details.create(category_name: default_category.name,
                                          category_id: default_category.id,
                                          sort_number: before_detail_count + index)
      end
    end
    
    # カテゴリ減少
    def decrease_category(category_id_arrey)
      category_id_arrey.each do |category_id|
        objects = @estimate.estimate_details.where(category_id: category_id)
        objects.each do |object|
          object.destroy
        end
      end
    end
    
    # 順番変更
    def change_category_order
      details = @estimate.estimate_details.sort_by{|detail| @after_category_arrey.index(detail.category_id)}
      details.each.with_index(1) do |detail, i|
        detail.update(sort_number: i * 100)
      end
    end
end
