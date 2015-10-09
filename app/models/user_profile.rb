class UserProfile < ActiveRecord::Base
  belongs_to :user
  GENDER = {male: 1, female: 2}
  after_save :user_info_validate


  def user_info_validate
    user = self.user
    if self.school.present? & self.grade.present? & self.gender.present? & self.age.present? & self.username.present?
      user.update_attributes(validate: 1)
    else
      user.update_attributes(validate: 0)
    end
  end
end
