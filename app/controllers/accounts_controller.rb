class AccountsController < ApplicationController
  def index
  end

  def send_code
    sms = SMSService.new(params[:mobile])
    data = sms.send_code(params[:type], params[:ip])
    render json: data
  end
  # def forget_password
  #
  # end

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

  def destroy
    cookies[:access_token] = nil
    flash[:notice] = '您已安全退出登录。'
    redirect_to action: :login
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