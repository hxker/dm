class Admin::TeamsController < AdminController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /admin/teams
  # GET /admin/teams.json
  def index
    if params[:field].present? && params[:keyword].present?
      if params[:field] == 'competition_id'
        competition = Competition.where(name: params[:keyword]).take
        @teams = Team.all.where(["#{params[:field]} like ?", competition.id]).page(params[:page]).per(params[:per])
      else
        @teams = Team.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
      end
    else
      @teams = Team.all.page(params[:page]).per(params[:per])
    end

  end

  # GET /admin/teams/1
  # GET /admin/teams/1.json
  def show
  end

  # GET /admin/teams/new
  def new
    @team = Team.new
  end

  # GET /admin/teams/1/edit
  def edit
  end

  # POST /admin/teams
  # POST /admin/teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to [:admin, @team], notice: '队伍创建成功' }
        format.json { render action: 'show', status: :created, location: @team }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/teams/1
  # PATCH/PUT /admin/teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to [:admin, @team], notice: '队伍更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/teams/1
  # DELETE /admin/teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to admin_teams_url, notice: '队伍删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :user_id, :competition_id, :team_code)
  end
end
