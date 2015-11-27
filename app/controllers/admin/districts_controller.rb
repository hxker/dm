class Admin::DistrictsController < AdminController
  before_action :set_district, only: [:show, :edit, :update, :destroy]

  # GET /admin/districts
  # GET /admin/districts.json
  def index
    if params[:field].present? && params[:keyword].present?
      @districts = District.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).per_page_kaminari(params[:page]).per(params[:per])
    else
      @districts = District.all.per_page_kaminari(params[:page]).per(params[:per])
    end
  end

  # GET /admin/districts/1
  # GET /admin/districts/1.json
  def show
  end

  # GET /admin/districts/new
  def new
    @district = District.new
  end

  # GET /admin/districts/1/edit
  def edit
  end

  # POST /admin/districts
  # POST /admin/districts.json
  def create
    @district = District.new(district_params)

    respond_to do |format|
      if @district.save
        format.html { redirect_to [:admin, @district], notice: '区县创建成功!' }
        format.json { render action: 'show', status: :created, location: @district }
      else
        format.html { render action: 'new' }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/districts/1
  # PATCH/PUT /admin/districts/1.json
  def update
    respond_to do |format|
      if @district.update(district_params)
        format.html { redirect_to [:admin, @district], notice: '区县更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/districts/1
  # DELETE /admin/districts/1.json
  def destroy
    @district.destroy
    respond_to do |format|
      format.html { redirect_to admin_districts_url, notice: '区县删除成功!' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_district
    @district = District.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def district_params
    params.require(:district).permit!
  end
end
