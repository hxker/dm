class Admin::TeamsController < AdminController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /admin/teams
  # GET /admin/teams.json
  def index
    team=Team.includes(:event, :district).all
    if params[:field].present? && params[:keyword].present?
      if params[:field] == 'event_id'
        event = Event.where(id: params[:keyword]).select(:id).take
        if event.present?
          @teams = team.where(["#{params[:field]} like ?", event.id]).where(group: [1]).page(params[:page]).per(params[:per])
        end
      else
        @teams = team.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).where(group: [1]).page(params[:page]).per(params[:per])
      end
    else
      @teams = team.page(params[:page]).per(params[:per])
    end
    if @teams.present?
      @teams_array = @teams.map { |t| {
          id: t.id,
          event: t.event.name+'-'+t.event.id.to_s,
          group: t.group,
          district: t.district.try(:name),
          school: t.try(:description),
          player: User.joins(:team_user_ships).where('team_user_ships.team_id=?', t.id).select('users.nickname').map { |u| u.nickname }.join('、'),
          teacher: t.try(:teacher),
      } }
    end

    respond_to do |format|
      format.html
      format.xls {
        data = @teams.select(:id, :event_id, :group, :description, :district_id, :teacher, :score_process, :last_score, :rank).map { |x| {
            队伍代码: x.id,
            所属比赛: x.event.name,
            组别: x.group== 1 ? '小学' : '中学',
            区县: x.district.try(:name),
            学校: x.try(:description),
            队员: User.joins(:team_user_ships).where('team_user_ships.team_id=?', x.id).select('users.nickname').map { |u| u.nickname }.join(' '),
            教师: x.try(:teacher),
        } }
        puts '12qwe'
        puts data
        # filename = "Team-Export-#{Time.now.strftime("%Y%m%d%H%M%S")}.xls"
        filename = "#{data[0][:所属比赛].to_s}-#{data[0][:组别]}.xls"
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
