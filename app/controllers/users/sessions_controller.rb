class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

# GET /resource/sign_in
  def new
    @resource = resource_class.new(sign_in_params)
    self.resource = @resource
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

# POST /resource/sign_in
  def create
    if params[:user][:login].present?
      user = User.where(['nickname = :value OR email = :value OR mobile = :value', {:value => resource_params[:login]}]).first
      if user.present?

        if session[:fail_times].present? && session[:fail_times] > 10
          if captcha_valid? params[:captcha]
            if user.valid_password?(params[:user][:password])
              super
              session[:fail_times] = 0
            else
              flash[:error] = '密码不正确'
              @resource = resource_class.new(sign_in_params)
              @resource.login = resource_params[:login]
              render action: 'new'
            end
          else
            flash[:error] = '校证码不正确'
            @resource = resource_class.new
            @resource.login = resource_params[:login]
            # redirect_to action: 'new'
            render action: 'new'
          end
        else
          if user.valid_password?(params[:user][:password])
            super
            session[:fail_times] = 0
          else
            if session[:fail_times].present?
              session[:fail_times] += 1
            else
              session[:fail_times] = 1
            end
            flash[:error] = '密码不正确'
            @resource = resource_class.new(sign_in_params)
            @resource.login = resource_params[:login]
            render action: 'new'
          end
        end
      else
        flash[:error] = '账户名不存在'
        @resource = resource_class.new(sign_in_params)
        @resource.login = resource_params[:login]
        render action: 'new'
      end
    else
      flash[:error] = '请输入账户名'
      @resource = resource_class.new(sign_in_params)
      redirect_to action: 'new'
    end
    # super
  end

# DELETE /resource/sign_out
# def destroy
#   super
# end

# protected

# If you have extra params to permit, append them to the sanitizer.
# def configure_sign_in_params
#   devise_parameter_sanitizer.for(:sign_in) << :attribute
# end
end
