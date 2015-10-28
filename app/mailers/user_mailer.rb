class UserMailer < ActionMailer::Base
  default from: 'DouMu<robodou@robodou.cn>'


  def valid_team_leader(user, code, team_name)
    @user = user
    @code = code
    @team_name = team_name
    email_with_name = "#{@user.nickname} <#{@user.email}>"
    # @url = 'http://example.com/login'
    mail(to: email_with_name, subject: '豆姆科技－队长重置队伍密钥')
  end
end