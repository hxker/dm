module API_v1
  class Users < Grape::API
    desc '用户信息'
    resource :users, desc: '用户相关' do

      desc '获取用户总数'
      get '/' do
        {status: TRUE, message: '成功获取用户总数', user_count: User.count}
      end

      desc '用户 access_token'
      params do
        requires :access_token, type: String, desc: "Access Token"
      end
      namespace ':access_token' do
        before do
          @current_user ||= User.authenticated_access_token(params[:access_token])
          unless @current_user.present?
            error!({status: FALSE, message: '401'}, 200)
          end
        end

        desc '获取用户信息'
        get '/' do
          {status: TRUE, message: '成功获取用户信息', user: @current_user}
        end

      end

    end

  end
end