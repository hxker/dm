class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!
  # def after_sign_in_path_for(resource)
  #   root_path
  # end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :nickname, :password, :password_confirmation, :captcha, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :nickname, :mobile, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def authenticate
    unless current_user.present?
      flash[:warning] = '您在进行下一步操作之前请登录或注册.'
      respond_to do |format|
        format.js { render js: "window.location = '#{new_user_session_path}'" }
      end
    end
  end
end
