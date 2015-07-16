class UserService

  # 注册
  def self.register(mobile, password, mobile_code)
    sing_up = SingUp.new(mobile: mobile, password: password, mobile_code: mobile_code)
    if sing_up.save
      [TRUE, '注册成功']
    else
      [FALSE, '注册失败']
    end
  end

  # 检测用户是否存在
  def self.check(mobile)
    user = User.find_by_mobile(mobile)
    if user.present?
      [TRUE, '用户存在']
    else
      [FALSE, '用户不存在']
    end
  end

  # 登录
  def self.login(mobile, password, ip)
    user = User.find_by_mobile(mobile)
    unless user.present?
      [FALSE, '用户不存在']
    end
    status, message= user.login(password, ip)
    if status
      [TRUE, message, user]
    else
      [FALSE, message]
    end
  end

  # 修改密码
  # def change_password(mobile, old_password, new_password)
  #   user = User.find_by_username(mobile)
  #   unless user.present?
  #     [FALSE, '用户不存在']
  #   end
  #   user.change_password(old_password, new_password)
  # end

  # 找回密码
  def self.reset_password(mobile, new_password, mobile_code)
    user = User.find_by_mobile(mobile)
    unless user.present?
      [FALSE, '用户不存在']
    end
    user.reset_password(new_password, mobile_code)
  end

end