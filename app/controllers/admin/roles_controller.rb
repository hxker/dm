class Admin::RolesController < AdminController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /admin/roles
  # GET /admin/roles.json
  def index
    if params[:field].present? && params[:keyword].present?
      @roles = Role.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @roles = Role.all.page(params[:page]).per(params[:per])
    end

  end

  # GET /admin/roles/1
  # GET /admin/roles/1.json
  def show
  end

  # GET /admin/roles/new
  def new
    @role = Role.new
  end

  # GET /admin/roles/1/edit
  def edit
  end

  # POST /admin/roles
  # POST /admin/roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to [:admin, @role], notice: '角色创建成功' }
        format.json { render action: 'show', status: :created, location: @role }
      else
        format.html { render action: 'new' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/roles/1
  # PATCH/PUT /admin/roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to [:admin, @role], notice: '角色更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/roles/1
  # DELETE /admin/roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to admin_roles_url, notice: '角色删除成功' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name)
    end
end
