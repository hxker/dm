class UserProfile < ActiveRecord::Base
  belongs_to :user
  has_many :team_user_ships, through: :user
  GENDER = {male: 1, female: 2}
  validates :age, allow_blank: true, format: {with: /\A[1-9][1-9]\Z/i, message: '请正确输入年龄'}
  after_commit :user_info_validate


  def user_info_validate
    user = self.user
    if self.school.present? & self.grade.present? & self.bj.present? & self.gender.present? & self.age.present? & self.username.present?
      user.update_attributes(validate: 1)
    else
      user.update_attributes(validate: 0)
    end
  end
end
