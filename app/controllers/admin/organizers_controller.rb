class Admin::OrganizersController < AdminController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]

  # GET /admin/organizers
  # GET /admin/organizers.json
  def index
    if params[:field].present? && params[:keyword].present?
      @organizers = Organizer.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @organizers = Organizer.all.page(params[:page]).per(params[:per])
    end

  end

  # GET /admin/organizers/1
  # GET /admin/organizers/1.json
  def show
  end

  # GET /admin/organizers/new
  def new
    @organizer = Organizer.new
  end

  # GET /admin/organizers/1/edit
  def edit
  end

  # POST /admin/organizers
  # POST /admin/organizers.json
  def create
    @organizer = Organizer.new(organizer_params)

    respond_to do |format|
      if @organizer.save
        format.html { redirect_to [:admin, @organizer], notice: '举办方创建成功.' }
        format.json { render action: 'show', status: :created, location: @organizer }
      else
        format.html { render action: 'new' }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/organizers/1
  # PATCH/PUT /admin/organizers/1.json
  def update
    respond_to do |format|
      if @organizer.update(organizer_params)
        format.html { redirect_to [:admin, @organizer], notice: '举办方更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/organizers/1
  # DELETE /admin/organizers/1.json
  def destroy
    @organizer.destroy
    respond_to do |format|
      format.html { redirect_to admin_organizers_url, notice: '举办方删除成功.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_organizer
    @organizer = Organizer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organizer_params
    params.require(:organizer).permit!
  end
end
