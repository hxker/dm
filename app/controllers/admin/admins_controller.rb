class Admin::AdminsController < AdminController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  before_action do
    authenticate_permissions(['admin'])
  end

  # GET /admin/admins
  # GET /admin/admins.json
  def index

    if params[:field].present? && params[:keyword].present?
      @admins = Admin.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @admins = Admin.all.per_page_kaminari(params[:page]).per(params[:per])
    end
  end

  # GET /admin/admins/1
  # GET /admin/admins/1.json
  def show
  end

  # GET /admin/admins/new
  def new
    @admin = Admin.new
  end

  # GET /admin/admins/1/edit
  def edit
  end

  # POST /admin/admins
  # POST /admin/admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to [:admin, @admin], notice: t('activerecord.models.admin') + ' 已成功创建.' }
        format.json { render action: 'show', status: :created, location: @admin }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/admins/1
  # PATCH/PUT /admin/admins/1.json
  def update
    # puts '123'
    # puts employee_params
    # render nothing: true
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to [:admin, @admin], notice: t('activerecord.models.admin') + ' 已成功更新.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/admins/1
  # DELETE /admin/admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admin_admins_url, notice: t('activerecord.models.admin') + ' 已成功删除.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_params
    params.require(:admin).permit(:job_number, :password, :name, {:permissions => []}, :position, :age, :gender, :email, :phone, :address).tap do |list|
      if params[:admin][:permissions].present?
        list[:permissions] = params[:admin][:permissions].join(',')
      else
        list[:permissions] = nil
      end
    end
  end
end

