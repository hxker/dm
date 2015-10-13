class User < ActiveRecord::Base
  has_many :team_user_ships, foreign_key: :user_id
  has_many :teams
  has_many :creative_activities
  has_many :likes, foreign_key: :user_id
  has_one :user_profile, :dependent => :destroy
  has_many :roles, through: :user_roles
  has_many :user_roles
  has_many :notifications

  mount_uploader :avatar, AvatarUploader

  # accepts_nested_attributes_for :user_profile, allow_destroy: true
  #
  # delegate :username, :gender, :birthday, :address, to: :user_profile, allow_nil: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :lockable, :timeoutable, :authentication_keys => [:login]


  validates :mobile, allow_blank: true, uniqueness: true, format: {with: /\A1[34578][0-9]{9}\Z/i, message: '格式不正确'}
  validates :email, allow_blank: true, uniqueness: true, format: {with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, message: '邮箱格式不正确'}
  validates :nickname, presence: true, uniqueness: true, length: 2..10, format: {with: /\A[\u4e00-\u9fa5_a-zA-Z0-9]+\Z/i, message: '昵称只能包含汉子、数字、字母、下划线'}
  validates :password, length: 6..20, format: {with: /\A[\x21-\x7e]+\Z/i, message: '密码只包含数字、字母、特殊字符'}, on: :create
  validate :validate_email_mobile
  after_create :create_uuid

  def validate_email_mobile
    if email.blank? && mobile.blank?
      errors[:email] << '手机或邮箱至少有一个不能为空'
    end
  end

  def email_changed?
    false
  end

  def email_required?
    false
  end

  def create_uuid
    unless self.uuid
      self.uuid = SecureRandom.uuid
      self.save
    end
  end

  attr_accessor :login
  attr_accessor :mobile_code

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['email = :value OR nickname = :value OR mobile = :value', {:value => login}]).first
    else
      where(conditions).first
    end
  end

end
