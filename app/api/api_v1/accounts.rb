module API_v1
  class Accounts < Grape::API
    resource :account, desc: '用户账户' do
      desc '检测邮箱是否已注册'
      params do
        requires :email, type: String, desc: '邮箱', regexp: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
      end
      get :check do
        status, message = UserService.check(params[:email])
        {status: status, message: message}
      end
    end

  end
end