class Employees::Settings::Companies::IndustriesController < Employees::Settings::CompaniesController
  before_action :set_industry, only: [:edit, :update, :destroy]

  def create
    @industry = Industry.new(industry_params)
    if @industry.save
      @responce = "success"
    else
      @responce = "failure"
    end
    set_industries
  end

  def update
    if @industry.update(industry_params)
      @responce = "success"
    else
      @responce = "failure"
    end
    set_industries
  end

  def destroy
    if @industry.destroy
      @responce = "success"
    else
      @responce = "failure"
    end
    set_industries
  end

  def sort
    from = params[:from].to_i + 1
    industry = Industry.find_by(position: from)
    industry.insert_at(params[:to].to_i + 1)
    set_industries
  end

  private
    def set_industry
      @industry = Industry.find(params[:id])
    end

    def industry_params
      params.require(:industry).permit(:name)
    end
end

