class Admin::TeamsController < AdminController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /admin/teams
  # GET /admin/teams.json
  def index
    team=Team.includes(:event).all
    if params[:field].present? && params[:keyword].present?
      if params[:field] == 'event_id'
        event = Event.where(name: params[:keyword]).select(:id).take
        if event.present?
          @teams = team.where(["#{params[:field]} like ?", event.id]).per_page_kaminari(params[:page]).per(params[:per])
        end
      else
        @teams = team.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).per_page_kaminari(params[:page]).per(params[:per])
      end
    else
      @teams = team.per_page_kaminari(params[:page]).per(params[:per])
    end

    respond_to do |format|
      format.html
      format.xls {
        data = team.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).select(:id, :name, :event_id, :score_process, :last_score, :rank).map { |x| {
            ID: x.id,
            名称: x.name,
            所属比赛: x.event.name,
            得分过程: x.score_process,
            最终成绩: x.last_score,
            名次: x.rank
        } }
        filename = "Team-Export-#{Time.now.strftime("%Y%m%d%H%M%S")}.xls"
        send_data(data.to_xls, :type => "text/xls;charset=utf-8,header=present", :filename => filename)

      }
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
