class Admin::RefereesController < AdminController
  before_action :set_referee, only: [:show, :edit, :update, :destroy]

  # GET /admin/referees
  # GET /admin/referees.json
  def index
    if params[:field].present? && params[:keyword].present?
      @referees = UserRole.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).per_page_kaminari(params[:page]).per(params[:per])
    else
      @referees = UserRole.where(role_id: 1).per_page_kaminari(params[:page]).per(params[:per])
    end
  end

  # GET /admin/referees/1
  # GET /admin/referees/1.json
  def show
  end

  # GET /admin/referees/new
  def new
    @referee = UserRole.new
  end

  # GET /admin/referees/1/edit
  def edit
  end

  # POST /admin/referees
  # POST /admin/referees.json
  def create
    @referee = Referee.new(referee_params)

    respond_to do |format|
      if @referee.save
        format.html { redirect_to [:admin, @referee], notice: 'Referee was successfully created.' }
        format.json { render action: 'show', status: :created, location: @referee }
      else
        format.html { render action: 'new' }
        format.json { render json: @referee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/referees/1
  # PATCH/PUT /admin/referees/1.json
  def update
    respond_to do |format|
      if @referee.update(referee_params)
        format.html { redirect_to [:admin, @referee], notice: 'Referee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @referee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/referees/1
  # DELETE /admin/referees/1.json
  def destroy
    @referee.destroy
    respond_to do |format|
      format.html { redirect_to admin_referees_url, notice: 'Referee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_referee
      @referee = Referee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def referee_params
      params.require(:referee).permit(:name)
    end
end
