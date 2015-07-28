class Admin < ActiveRecord::Base

  has_secure_password
  include AccountConcern

  validates :job_number, presence: true, length: {minimum: 3, maximum: 5}, uniqueness: true
  validates :password, length: {minimum: 6, maximum: 20}, allow_blank: true
  validates :password, presence: true, on: :create
  validates :name, presence: true

  PERMISSIONS = {
      super_admin: '超级管理员',
      admin: '管理员',
      teacher: '教师',

  }

  GENDER = {male: 1, female: 2}

  def auth_permissions(permissions)
    if permissions.is_a?(Array) and self.permissions.present?
      (self.permissions.split(',') & permissions).count > 0
    else
      FALSE
    end
  end


end
