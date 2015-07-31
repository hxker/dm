class ResetMobile

  include Virtus::Model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :password, String
  attribute :mobile_code, String
  attribute :new_mobile, String

  validates :new_mobile, presence: true, length: {is: 11}, numericality: true
  validates :password, presence: true, length: {minimum: 6, maximum: 20}
  validates :mobile_code, presence: true, length: {is: 4}
  validate :mobile_code_validation


  def mobile_code_validation
    sms = SMSService.new(self.new_mobile)
    status, message = sms.validate?(self.mobile_code, SMSService::TYPE_CODE_RESET_MOBILE)
    unless status
      errors[:mobile_code] << message
    end
  end

  def persisted?
    FALSE
  end

end