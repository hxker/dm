require 'rexml/document'

class SMSService

  TYPE_CODE_REGISTER = 'REGISTER'
  TYPE_CODE_RESET_PASSWORD = 'RESET_PASSWORD'
  TYPE_CODE_RESET_MOBILE = 'RESET_MOBILE'
  TYPE_CODE_ADD_MOBILE = 'ADD_MOBILE'
  TYPE_CODE_RESET_TEAM_CODE = 'RESET_TEAM_CODE'

  #接口变量定义
  URL = 'http://smsapi.c123.cn/OpenPlatform/OpenApi'; #接口地址
  SEND_TYPE = 'sendOnce'; #发送类型 ，可以有sendOnce短信发送，sendBatch一对一发送，sendParam	动态参数短信接口
  # CHANNEL_ID = '1574'; #通道组编号
  CHANNEL_ID = '5552'; #通道组编号
  SIGNATURE_ID = ''; #签名编号 ,可以为空时，使用系统默认的编号
  SEND_TIME = ''; #发送时间,可以为空表示立即发送,yyyyMMddHHmmss 如:20130721182038
  WAIT_MINUTE = 2; # 发送间隔
  EFFECTIVE_TIME = 10; # 有效时间
  ALLOW_VALIDATE_TIMES = 5; # 允许尝试次数
  IS_TEST = false; # 测试模式不发送短信

  # 构造方法
  def initialize(mobile)
    @mobile = mobile
  end

  def send_message(message)
    unless Regular.is_mobile?(@mobile)
      return [FALSE, '手机号码格式错误']
    end
    user = User.find_by(mobile: @mobile)
    if user.nil?
      [FALSE, '用户不存在']
    else
      send(message)
      [TRUE, '消息已发送']
    end
  end

  # 发送消息
  def send(message)
    unless Regular.is_mobile?(@mobile)
      return [FALSE, '手机号码格式错误']
    end
    status = http_send_message(message)
    [status, status ? '短信发送成功' : '短信发送失败']
  end

  # 发送验证码
  def send_code(type, ip)
    unless Regular.is_mobile?(@mobile)
      return [FALSE, '手机号码格式错误']
    end
    if MobileCode.where('created_at > ?', Time.now - 300).count > 10
      return [FALSE, '发送密度过大，请稍等重试']
    end
    user = User.find_by(mobile: @mobile)
    if user.blank? and type == TYPE_CODE_RESET_PASSWORD
      return [FALSE, '用户不存在']
    elsif user.present? and (type == TYPE_CODE_REGISTER || type == TYPE_CODE_RESET_MOBILE || type == TYPE_CODE_ADD_MOBILE)
      return [FALSE, '手机号码已被使用']
    end
    code = get_mobile_code # 获取随机码
    row = MobileCode.find_by(mobile: @mobile, message_type: type) # 检测是否已经存在同类型记录
    if row.nil?
      MobileCode.create!(mobile: @mobile, code: code, message_type: type, ip: ip) # 如果不存在则直接生成新记录
    elsif row.updated_at + WAIT_MINUTE * 60 < Time.now
      # 如果存在同类型记录，但已经超过发送间隔，则根据新的代码重新发送
      row.code = code
      row.save
    else
      # 如果存在同类型记录，但小于发送间隔，则不重新发送
      return [FALSE, "验证码发送间隔为#{WAIT_MINUTE}分钟"]
    end
    # 根据类型发送不同消息
    status = FALSE
    status = send_code_for_register(code) if type == TYPE_CODE_REGISTER
    status = send_code_for_reset_password(code) if type == TYPE_CODE_RESET_PASSWORD
    status = send_code_for_reset_mobile(code) if type == TYPE_CODE_RESET_MOBILE
    status = send_code_for_add_mobile(code) if type == TYPE_CODE_ADD_MOBILE
    status = send_code_for_reset_team_code(code) if type == TYPE_CODE_RESET_TEAM_CODE
    if status
      [TRUE, '验证码发送成功']
    else
      [FALSE, '验证码发送失败']
    end
  end

  # 检测手机验证码
  def validate?(code, type)
    # unless code.length == 4
    #   return [FALSE, '验证码只能为4位']
    # end
    unless Regular.is_mobile?(@mobile)
      return [FALSE, '手机号码格式错误']
    end

    # 检测手机验证码格式
    unless Regular.is_mobile_code?(code)
      return [FALSE, '验证码格式错误']
    end

    # 获取验证码纪录，如果不存在返回 FALSE
    row = MobileCode.find_by(mobile: @mobile, code: code, message_type: type)
    if row.nil?
      return [FALSE, '验证码不正确']
    end

    # 检测是否超时及是否超过尝试次数
    if (row.updated_at + EFFECTIVE_TIME * 60 < Time.now) or (row.failed_attempts.to_i + 1 >= ALLOW_VALIDATE_TIMES)
      row.destroy
      return [FALSE, "验证码已超时或尝试超过#{ALLOW_VALIDATE_TIMES}次"]
    end

    #检测验证码是否正确，如不正确增加1次尝试次数
    if row.code == code
      row.destroy
      [TRUE, '验证码成功通过验证']
    else
      row.failed_attempts = row.failed_attempts.to_i + 1
      row.save
      [FALSE, '验证码错误']
    end
  end


  # 私有方法
  private

  def get_mobile_code
    rand(1000..9999)
  end

  def http_send_message(message)
    uri = URI(URL)
    res = Net::HTTP.post_form(uri, 'm' => @mobile, 'c' => message, 'action' => SEND_TYPE, 'ac' => ACCOUNT,
                              'authkey' => AUTH_KEY, 'cgid' => CHANNEL_ID, 'csid' => SIGNATURE_ID, 't' => SEND_TIME)
    xml = res.body
    doc = REXML::Document.new xml
    result = doc.root.attributes['result']
    result == 1
  end

  #发送验证码 － 注册
  def send_code_for_register(code)
    message = "您正通过手机注册豆姆账户，验证码为：#{code}，#{EFFECTIVE_TIME}分钟内有效，请尽快完成验证。"
    send(message)
  end

  #发送验证码 － 找回密码
  def send_code_for_reset_password(code)
    message = "您正通过手机找回在豆姆的账户密码，验证码为：#{code}，#{EFFECTIVE_TIME}分钟内有效，请尽快完成验证。"
    send(message)
  end

  #发送验证码 － 修改手机号
  def send_code_for_reset_mobile(code)
    message = "您正通过手机修改在豆姆账户的手机号，验证码为：#{code}，#{EFFECTIVE_TIME}分钟内有效，请尽快完成验证。"
    send(message)
  end

  #发送验证码 － 添加手机号
  def send_code_for_add_mobile(code)
    message = "您正通过手机为您的豆姆账户添加手机号信息，验证码为：#{code}，#{EFFECTIVE_TIME}分钟内有效，请尽快完成验证。"
    send(message)
  end

  #发送验证码 － 重置队伍密钥
  def send_code_for_reset_team_code(code)
    message = "您正通过手机重置您在豆姆组建队伍的密钥，验证码为：#{code}，#{EFFECTIVE_TIME}分钟内有效，请尽快完成验证。"
    send(message)
  end
end
