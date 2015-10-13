class CompetitionsController < ApplicationController
  before_action :authenticate_user!, only: [:apply_in, :team]

  def index
    @competitions = Competition.includes(:organizer).all.page(params[:page]).per(params[:per])
  end

  def show
    @competition = Competition.find(params[:id])
    @teams = Team.where(event_id: params[:id])
  end

  def shows
    @competition = Competition.find(1)
    @events = Event.where(competition_id: @competition.id)
  end

  def apply_in
    @competition = Competition.find(params[:id])
    @events = Event.where(competition_id: params[:id])
    @teams = Team.where(event_id: params[:id])
    @already = TeamUserShip.where(user_id: current_user.id, event_id: params[:id]).take
  end

  def reset_team_code_by_mobile
    sms = SMSService.new(params[:mobile])
    status, message = sms.validate?(params[:mobile_code], SMSService::TYPE_CODE_RESET_TEAM_CODE)
    if status
      team = Team.find(params[:team_id])
      team.team_code = params[:new_team_code]
      if team.save
        message = '队伍密钥重置成功!'
      else
        message = '队伍密钥重置过程失败'
      end
    end
    render json: [status, message]
  end

  def send_email_code
    team_name = Team.find(params[:team_id]).name
    ec = EmailService.new(params[:email])
    data = ec.send_email_code(current_user, params[:type], params[:ip], team_name)
    render json: data
  end

  def reset_team_code_by_email
    ec = EmailService.new(params[:email])
    status, message = ec.validate?(params[:email_code], EmailService::TYPE_CODE_RESET_TEAM_CODE)
    if status
      team = Team.find(params[:team_id])
      team.team_code = params[:new_team_code]
      if team.save
        message = '队伍密钥重置成功!'
      else
        message = '队伍密钥重置过程失败'
      end
    end
    render json: [status, message]
  end


  def reduce_team_amount
    team_user = TeamUserShip.where(user_id: params[:user_id], team_id: params[:team_id]).take
    team_user.destroy
    if team_user.destroy
      flash[:success] = '成功退出该队!'
      redirect_to '/competitions/apply_in/?id='+ params[:competition_id]
    end
  end

  def team
  end

  def add_user_apply_info
    if params[:username].present? and params[:age].present? and params[:school].present? and params[:grade].present?
      user = UserProfile.find_by(user_id: current_user.id)
      if user.present?
        user.username = params[:username]
        user.age = params[:age]
        user.school = params[:school]
        user.grade = params[:grade]
        if user.save
          status = true
          message = '个人信息确认成功'
        else
          status = false
          message = '个人信息更新失败'
        end
      else
        up = UserProfile.create!(user_id: current_user.id, username: params[:username], age: params[:age], school: params[:school], grade: params[:grade])
        if up.save
          status = true
          message = '个人信息添加成功'
        else
          status = false
          message = '个人信息添加失败'
        end
      end
    else
      status = false
      message = '个人信息输入不完整'
    end
    render json: [status, message]

  end

  # def valid_apply
  #   user = User.find(params[:user_id])
  #   if user.username.present?
  #     status = true
  #   else
  #     status = false
  #     message = '您的个人信息不完整，请填写完整'
  #   end
  #   render json: [status, message]
  # end

  def valid_team_code
    result = Team.find(params[:team_id])
    if result.team_code == params[:team_code]
      team_user = TeamUserShip.where(user_id: current_user.id, team_id: params[:team_id]).take
      if team_user.present?
        status = false
        message = '您已经是该队伍成员，无需加入!'
      else
        add_team_user = TeamUserShip.create!(user_id: current_user.id, team_id: params[:team_id], event_id: params[:event_id])
        if add_team_user.save
          status = true
          message = '成功加入该队!'
        else
          status = false
          message = '加入失败!'
        end
      end
    else
      status = false
      message = '队伍密钥不正确'
    end
    render json: [status, message]
  end

  def valid_create_team
    user_id = current_user.id
    t = TeamUserShip.where(user_id: user_id, event_id: params[:event_id]).take
    team_name = Team.where(event_id: params[:event_id], name: params[:team_name]).take
    if t.present?
      result = [false, '该比赛您已经报名，请不要再次报名!']
    elsif team_name.present?
      result = [false, '很抱歉，该比赛中队伍['+team_name.name+']已存在，请更改队伍名称!']
    else
      team = Team.create!(name: params[:team_name], user_id: user_id, teacher: params[:teacher], event_id: params[:event_id], team_code: params[:team_code], cover: params[:cover])
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

  def apply
    @competition =Competition.find(params[:id])
  end
end
