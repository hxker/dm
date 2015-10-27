class AdminController < ActionController::Base
  before_action :set_current_admin, :authenticate

  def index
    # render nothing: true

    # 用户总数
    @all_user_num = User.count
    @all_creative_activities = CreativeActivity.count
    @on_audit = CreativeActivity.where(is_audit: 0).count
    @no_audit = CreativeActivity.where(is_audit: 2).count


  end

  protected

  def set_current_admin
    begin

      # access_token 验证模式
      @current_admin ||= Admin.authenticated_access_token(cookies[:access_token])
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def authenticate
    unless @current_admin.present?
      redirect_to controller: 'admin/accounts', action: 'new'
    end
  end

  def authenticate_permissions(permissions)
    authenticate
    unless @current_admin.auth_permissions(permissions)
      render text: '没有权限'
    end
    FALSE
  end

end
