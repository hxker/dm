class UserService

  # 检测邮箱是否存在
  def self.check(email)
    exist = User.where(email: email).exists?
    if exist
      [TRUE, '该邮箱已被使用']
    else
      [FALSE, '该邮箱未被使用']
    end
  end
end