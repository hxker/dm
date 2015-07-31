class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :lockable, :timeoutable, :authentication_keys => [:login]


  alias :devise_valid_password? :valid_password?

  # validates :username, length: {in: 4..20}
  validates :nickname, presence: true, uniqueness: true, length: {minimum: 3, maximum: 10}
  validate :validate_email_mobile

  def validate_email_mobile
    if email.blank? && mobile.blank?
      errors[:email] << '邮箱不能为空'
    end
  end

  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value OR lower(nickname) =  :value OR lower(mobile) =  :value", {:value => login.downcase}]).first
    else
      where(conditions).first
    end
  end

  def valid_password?(password)
    begin
      devise_valid_password?(password)
    rescue BCrypt::Errors::InvalidHash
      if salt == self.salt
        digest = "#{password}{#{salt}}"
      else
        digest = password
      end
      return false unless Digest::SHA512.hexdigest(digest) == encrypted_password
      # Rails.logger.info "User #{email} is using Symfony encryption, updating attribute."
      self.password = password
      self.salt = nil
      self.save
      true
    end
  end

end
