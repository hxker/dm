module AccountConcern
  extend ActiveSupport::Concern

  # 登录方法
  def login(password, ip)
    unless self.present?
      return [FALSE, '用户不存在']
    end
    unless password.present?
      return [FALSE, '密码不能为空']
    end
    if self.failed_attempts.to_i >= 10
      return [FALSE, '账户已被锁定，请及时联系管理员']
    end
    if self.try(:authenticate, password)
      # 转移上次IP及时间纪录
      self.last_sign_in_at = self.current_sign_in_at
      self.last_sign_in_ip = self.current_sign_in_ip
      # 当前IP及时间纪录
      self.current_sign_in_at = Time.now
      self.current_sign_in_ip = ip
      # 登录次数累计
      self.sign_in_count = self.sign_in_count.to_i + 1
      # 解锁状态清除
      self.failed_attempts = 0
      self.locked_at = nil
      # 生成 access_token
      self.last_activity_at = Time.now
      self.access_token = self.generate_access_token
      self.save
      [TRUE, '登录成功']
    else
      self.failed_attempts = self.failed_attempts.to_i + 1
      self.locked_at = Time.now if self.failed_attempts.to_i == 10
      self.save
      mod = 10 - self.failed_attempts.to_i
      message = '密码错误'
      if mod == 0
        message = message + '，账户已被锁定，请及时联系管理员'
      elsif mod < 4
        message = message + "，还剩 #{mod} 次尝试的机会"
      end
      [FALSE, message]
    end
  end



  def reset_password(new_password, mobile_code, not_validate_code = false)
    unless self.present?
      return [FALSE, '用户不存在']
    end
    unless new_password.present?
      return [FALSE, '密码不能为空']
    end
    unless new_password.length >= 6
      return [FALSE, '密码不能少于6位']
    end
    if self.failed_attempts.to_i >= 10
      return [FALSE, '账户已被锁定，请及时联系管理员']
    end
    unless not_validate_code
      sms = SMSService.new(self.username)
      status, message = sms.validate?(mobile_code, SMSService::TYPE_CODE_RESET_PASSWORD)
      unless status
        return [FALSE, message]
      end
    end
    self.password = new_password
    if self.save
      [TRUE, '密码已成功修改']
    else
      [FALSE, '密码修改过程出错']
    end
  end

  # 生成 access_token
  def generate_access_token

    Digest::SHA2.hexdigest("#{self.class}:#{self.id}:#{self.current_sign_in_at}")
  end

  # 导入验证 access_token 的方法
  included do
    # 通过 access_token 获取用户
    def self.authenticated_access_token(access_token)
      unless access_token.present?
        return nil
      end
      u = self.find_by_access_token(access_token)
      unless u.present?
        return nil
      end

      time = Time.now
      if u.last_activity_at.to_datetime > time - 25.minutes
        if u.last_activity_at.to_datetime < time - 5.minutes
          u.last_activity_at = time
          u.save
        end
        u
      else
        nil
      end
    end
  end

end