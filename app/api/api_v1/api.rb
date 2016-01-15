module API_v1
  class API < Grape::API

    version 'v1', using: :path
    prefix 'api'
    format :json
    content_type :txt, 'text/plain'
    default_error_formatter :txt

    # rescue_from :all do |e|
    #   case e
    #     when ActiveRecord::RecordNotFound
    #       Rack::Response.new([{error: '数据不存在'}.to_json], 404, {}).finish
    #     when Grape::Exceptions::ValidationErrors
    #       Rack::Response.new([{
    #                               error: '参数不符合要求，请检查参数是否按照 API 要求传输。',
    #                               validation_errors: e.errors
    #                           }.to_json], 400, {}).finish
    #     else
    #       # ExceptionNotifier.notify_exception(e) # Uncommit it when ExceptionNotification is available
    #       if Rails.env.test?
    #         Rails.logger.error "Error: #{e}\n#{e.backtrace[0, 3].join("\n")}"
    #       else
    #         Rails.logger.error "Api V1 Error: #{e}\n#{e.backtrace.join("\n")}"
    #       end
    #       Rack::Response.new([{error: 'API 接口异常'}.to_json], 500, {}).finish
    #   end
    # end

    mount API_v1::Accounts


    add_swagger_documentation api_version: 'v1',
                              hide_documentation_path: true,
                              mount_path: '/docs',
                              hide_format: true
  end
end