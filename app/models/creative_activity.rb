class CreativeActivity < ActiveRecord::Base
  belongs_to :user

  mount_uploader :cover, CoverUploader

end
