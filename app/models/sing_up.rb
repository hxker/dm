class SingUp

  include Virtus::Model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :mobile, String
  attribute :password, String
  attribute :mobile_code, String
  attribute :not_validate_code, Boolean

  validates :mobile, presence: true, length: {is: 11}, numericality: true
  validates :password, presence: true, length: {minimum: 6, maximum: 20}
  validates :mobile_code, presence: true, length: {is: 4}
  validate :register_validation
  validate :mobile_code_validation

  def register_validation
    if User.find_by(mobile: mobile).present?
      errors[:mobile] << "手机号码已被注册"
    end
  end

  def mobile_code_validation
    unless not_validate_code
      sms = SMSService.new(mobile)
      status, message = sms.validate?(mobile_code, SMSService::TYPE_CODE_REGISTER)
      unless status
        errors[:mobile_code] << message
      end
    end
  end

  def persisted?
    FALSE
  end

  def save
    if valid?
      sing_up
    else
      nil
    end
  end

  private

  def sing_up
    user = User.new(mobile: mobile, password: password)

    user.save ? user : nil
  end
end