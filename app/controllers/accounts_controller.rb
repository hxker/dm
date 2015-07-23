class AccountsController < ApplicationController
  def index
  end

  def send_code
    sms = SMSService.new(params[:mobile])
    data = sms.send_code(params[:type], params[:ip])
    render json: data
  end

  # 验证邮箱是否已经注册
  def register_email_exists
    result = User.find_by_email(params[:email])
    if result.present?
      status = true
    else
      status = false
    end
    render json: status
  end

  # 验证手机是否已经注册
  def register_mobile_exists
    result = User.find_by_mobile(params[:mobile])
    if result.present?
      status = true
    else
      status = false
    end
    render json: status
  end

  # 验证昵称是否已经注册
  def register_nickname_exists
    result = User.find_by_nickname(params[:nickname])
    if result.present?
      status = true
    else
      status = false
    end
    render json: status
  end

  def register
    if @current_user.present?
      redirect_to root_path
      return
    end
    @sing_up = SingUp.new
  end

  def register_post
    if @current_user.present?
      redirect_to root_path
      return
    end
    @sing_up = SingUp.new(params[:sing_up])
    user = @sing_up.save
    if user.present?
      flash[:success] = '注册成功。'
      redirect_to_url
    else
      render :register
    end
  end

  def reset_password
    if @current_user.present?
      redirect_to root_path
      return
    end
    @reset_password = ResetPassword.new
  end

  def reset_password_post
    if @current_user.present?
      redirect_to root_path
      return
    end
    @reset_password = ResetPassword.new(params[:reset_password])
    if @reset_password.save
      flash[:success] = '密码已经成功重置'
      redirect_to root_path
    else
      render :reset_password
    end
  end

  private

  def redirect_to_url
    if cookies[:redirect_url].present?
      redirect_url = cookies[:redirect_url]
      cookies[:redirect_url] = nil
      redirect_to redirect_url
    else
      redirect_to root_path
    end
  end
end