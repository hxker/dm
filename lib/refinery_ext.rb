Refinery::AdminController.class_eval do
  before_action :set_current_admin, :authenticate

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

end