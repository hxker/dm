class Admin::EventsController < AdminController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /admin/events
  # GET /admin/events.json
  def index
    if params[:field].present? && params[:keyword].present?
      @events = Event.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @events = Event.all.page(params[:page]).per(params[:per])
    end
  end

  # GET /admin/events/1
  # GET /admin/events/1.json
  def show
    @users = User.where(validate: 1)
  end


  # GET /admin/events/new
  def new
    @event = Event.new
  end

  # GET /admin/events/1/edit
  def edit
  end

  # POST /admin/events
  # POST /admin/events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to [:admin, @event], notice: '比赛项目创建成功' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def scores
    @event = Event.find(params[:id])
    @scores = Score.where(event_id: params[:id]).page(params[:page]).per(params[:per])
  end

  ## 添加比赛成绩
  def add_score
    @score = Score.new
    # @competition = Competition.find(params[:id])
    if params[:sid].present?
      @plus_score = Score.find(params[:sid])
      @score.event_id = @plus_score.event_id
      @score.comp_name = @plus_score.comp_name
      @score.kind = @plus_score.kind
      @score.th = @plus_score.th
      @score.team1_id = @plus_score.team1_id
      @score.team2_id = @plus_score.team2_id
      @score.score1 = @plus_score.score1
      @score.score2 = @plus_score.score2
      @score.referee_id = @plus_score.referee_id
    end


    if request.method == 'POST'

      @score = Score.new(score_params)
      respond_to do |format|
        if @score.save
          format.html { redirect_to "#{scores_admin_events_path}?id=#{@score.event_id}", notice: '成绩添加成功.' }
          format.json { render action: 'add_score', status: :created, location: @score }
        else
          format.html { render action: 'add_score' }
          format.json { render json: @score.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # 编辑比赛成绩
  def edit_score
    @score = Score.find(params[:id])
    if request.method == 'POST'
      respond_to do |format|
        if @score.update(score_params)
          format.html { redirect_to "#{scores_admin_events_path}?id=#{@score.event_id}", notice: '成绩更新成功' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit_score' }
          format.json { render json: @score.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def teams
    @event = Event.find(params[:id])
    @teams = Team.where(event_id: params[:id]).page(params[:page]).per(params[:per])
    @users = User.includes(:user_profile).where(validate: 1).where.not(id: TeamUserShip.where(event_id: params[:id]).pluck(:user_id)).select(:id, :nickname)
  end

  def create_team
    user_id = params[:user_id]
    t = TeamUserShip.where(user_id: user_id, event_id: params[:event_id]).take
    team_name = Team.where(event_id: params[:event_id], name: params[:team_name]).take
    if t.present?
      result = [false, '该队长已经报名此比赛,不能参与两个队伍!']
    elsif team_name.present?
      result = [false, '很抱歉，该比赛中队伍['+team_name.name+']已存在，请更改队伍名称!']
    else
      team = Team.create!(name: params[:team_name], user_id: user_id, event_id: params[:event_id], team_code: params[:team_code], teacher: params[:teacher])
      team_user_ship = TeamUserShip.create!(team_id: team.id, user_id: team.user_id, event_id: params[:event_id])
      if team.save && team_user_ship.save
        result = [true, '队伍['+team.name+']创建成功!']
      else
        team_user_ship.destroy
        result = [false, '队伍创建失败']
      end
    end
    render json: result
  end

  def add_team_player
    user_ids = params[:user_ids]
    team_id = params[:team_id]
    # event_id = params[:event_id]
    if user_ids.length > 4
      result = [false, '一次最多添加四名队员']
    else
      message = ''
      user_ids.each do |ud|
        user = User.find(ud)
        player = TeamUserShip.new(team_id: team_id, user_id: ud)#, event_id: event_id)
        player.save
        if player.save
          message = user.nickname + '添加成功' + message.to_s
        else
          message = user.nickname + '添加失败' + message.to_s
        end
      end
      result = [true, message]
    end
    render json: result
  end


  def delete_team_player
    user_id = params[:user_id]
    team_id = params[:team_id]
    player = TeamUserShip.where(user_id: user_id, team_id: team_id).take
    player.destroy
    if player.destroy
      result = [true, '删除成功']
    else
      result = [false, '删除失败']
    end
    render json: result
  end

  def delete_team
    Team.delete(params[:team_id])
    players = TeamUserShip.where(team_id: params[:team_id])
    players.delete_all
    if players.delete_all
      result = [true, '删除成功']
    else
      result = [false, '删除失败']
    end
    render json: result
  end

  # PATCH/PUT /admin/events/1
  # PATCH/PUT /admin/events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to [:admin, @event], notice: '比赛项目更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/events/1
  # DELETE /admin/events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to admin_events_url, notice: '比赛项目删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit!
  end

  def score_params
    params.require(:score).permit(:event_id, :comp_name, :kind, :th, :team1_id, :team2_id, :score1, :score2, :referee_id, :operator)
  end
end
