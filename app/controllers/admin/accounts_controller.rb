class Admin::AccountsController < AdminController

  skip_before_action :authenticate, only: [:new, :create, :destroy]
  layout 'bootstrap'

  def new
    # @category = Category.new
  end

  def index
    redirect_to '/admin/'
  end

  def create
    emp = Admin.find_by(job_number: params[:job_number])
    cookies[:job_number] = params[:job_number]
    if emp.blank?
      flash[:error] = '工号不存在'
      render action: 'new'
    elsif not emp.auth_permissions(['admin', 'super_admin', 'teacher'])
      flash[:error] = '此账号没有权限登录'
      render action: 'new'
    else
      status, message = emp.login(params[:password], request.remote_ip)
      if status
        flash[:notice] = message
        sing_in(emp)
        redirect_to '/admin/'
      else
        flash[:error] = message
        render action: 'new'
      end
    end
  end

  def destroy
    # sign_out
    # redirect_to root_path
    sing_out
    flash[:error] = '您已成功退出'
    redirect_to action: :new
  end

  def change_password
    render :layout => 'admin'
  end

  def change_password_post
    if @current_admin && @current_admin.authenticate(params[:password]) && (@current_admin.password = params[:new_password]; @current_admin.save)
      session[:employee_id] = nil
      flash[:error] = '密码已成功修改，请重新登录'
      redirect_to action: :new
    else
      flash[:error] = '密码修改过程出错'
      redirect_to action: :change_password
    end
  end

  private

  def sing_in(emp)
    cookies[:access_token] = emp.access_token
  end

  def sing_out
    cookies[:access_token] = nil
  end
end