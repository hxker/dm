class Admin::CompetitionsController < AdminController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]

  # GET /admin/competitions
  # GET /admin/competitions.json
  def index
    if params[:field].present? && params[:keyword].present?
      @competitions = Competition.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @competitions = Competition.all.page(params[:page]).per(params[:per])
    end
  end

  # GET /admin/competitions/1
  # GET /admin/competitions/1.json
  def show
    @users = User.where(validate: 1)
  end

  # GET /admin/competitions/new
  def new
    @competition = Competition.new
  end

  # GET /admin/competitions/1/edit
  def edit
  end

  # POST /admin/competitions
  # POST /admin/competitions.json
  def create
    @competition = Competition.new(competition_params)
    respond_to do |format|
      if @competition.save
        format.html { redirect_to [:admin, @competition], notice: '比赛创建成功.' }
        format.json { render action: 'show', status: :created, location: @competition }
      else
        format.html { render action: 'new' }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/competitions/1
  # PATCH/PUT /admin/competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to [:admin, @competition], notice: '比赛更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/competitions/1
  # DELETE /admin/competitions/1.json
  def destroy
    @competition.destroy
    respond_to do |format|
      format.html { redirect_to admin_competitions_url, notice: '比赛删除成功.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_competition
    @competition = Competition.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def competition_params
    params.require(:competition).permit(:name, {:guide_units => []}, {:organizer_units => []}, {:support_units => []}, {:help_units => []}, {:undertake_units => []}, :team_min_num, :team_max_num, :description, :cover, :status, :apply_start_time, :apply_end_time, :start_time, :end_time, :keyword).tap do |list|
      if params[:competition][:guide_units].present?
        list[:guide_units] = params[:competition][:guide_units].join(',')
      else
        list[:guide_units] = nil
      end
      if params[:competition][:organizer_units].present?
        list[:organizer_units] = params[:competition][:organizer_units].join(',')
      else
        list[:organizer_units] = nil
      end
      if params[:competition][:support_units].present?
        list[:support_units] = params[:competition][:support_units].join(',')
      else
        list[:support_units] = nil
      end
      if params[:competition][:help_units].present?
        list[:help_units] = params[:competition][:help_units].join(',')
      else
        list[:help_units] = nil
      end
      if params[:competition][:undertake_units].present?
        list[:undertake_units] = params[:competition][:undertake_units].join(',')
      else
        list[:undertake_units] = nil
      end
    end
  end
end
