module AdminHelper

  def show_status(bool)
    (bool ? '<label class="label label-success">是</label>' : '<label class= "label label-default">否</label>').html_safe
  end

  def show_permissions(admin)
    html = ''
    if admin.permissions.present?
      permissions = admin.permissions.split(',')
      Admin::PERMISSIONS.each do |id, name|
        if permissions.include?(id.to_s)
          html += '<label class="label label-success">' + name + '</label> '
        end
      end
    end
    html.html_safe
  end

  # 根据用户权限显示相应菜单
  def authenticate_permissions_show(permissions)
    if permissions.is_a?(Array) and @current_admin.permissions.present?
      (@current_admin.permissions.split(',') & permissions).count > 0
    else
      FALSE
    end
  end


end
