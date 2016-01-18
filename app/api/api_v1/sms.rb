module API_v1
  class Sms < Grape::API

    resource :sms, desc: '手机短信' do

      desc '发送验证码'
      params do
        requires :mobile, type: String, desc: '手机号码'
        requires :type, type: String, desc: '类型'
        requires :ip, type: String, desc: 'ip地址'
      end
      post :send_code do
        sms = SMSService.new(params[:mobile])
        sms.send_code(params[:type], params[:ip])
      end

    end
  end
end