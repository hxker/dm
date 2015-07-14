class AccountsController < ApplicationController
  def index
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
    @sing_up.wx_openid = session[:wx_openid] if @sing_up.wx_bind
    user = @sing_up.save
    if user.present?
      if @sing_up.wx_bind && session[:wx_openid].present?
        user.bing_wx(session[:wx_openid])
      end
      flash[:success] = '注册成功。'
      sing_in(user)
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
      redirect_to user_path
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

  def sing_in(user, remember = false, wx_bind = false)
    # cookies[:access_token] = {value: user.access_token, domain: '.yicheyanghu.com'}
    cookies[:access_token] = user.access_token
    if remember
      if user.is_enterprise?
        cookies[:enterprise_username] = {value: user.username, expires: 7.day.from_now}
      else
        cookies[:username] = {value: user.username, expires: 7.day.from_now}
      end
    else
      if user.is_enterprise?
        cookies.delete(:enterprise_username)
      else
        cookies.delete(:username)
      end
    end
    if !(user.is_enterprise?) and wx_bind and session[:wx_openid].present?
      user.wx_openid = session[:wx_openid]
      user.save
    end
  end
end