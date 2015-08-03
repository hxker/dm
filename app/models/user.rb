class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :lockable, :timeoutable, :authentication_keys => [:login]


  # validates :username, length: {in: 4..20}
  validates :nickname, presence: true, uniqueness: true, length: {minimum: 3, maximum: 10}
  validate :validate_email_mobile

  def validate_email_mobile
    if email.blank? && mobile.blank?
      errors[:email] << '邮箱不能为空'
    end
  end

  attr_accessor :login
  attr_accessor :mobile_code

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value OR lower(nickname) =  :value OR lower(mobile) =  :value", {:value => login.downcase}]).first
    else
      where(conditions).first
    end
  end

end
