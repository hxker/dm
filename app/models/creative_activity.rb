class CreativeActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :users, through: :likes
  has_many :likes, foreign_key: :creative_activity_id

  validates :name, presence: true, length: {in: 1..20}
  validates :user_id, presence: true
  validates :cover, presence: true
  before_validation :validate

  def validate
    unless cover.present?
      errors[:cover] << '请上传一张海报(图片)'
    end
  end

  mount_uploader :cover, CoverUploader
  mount_uploader :file, FileUploader
  mount_uploader :media, MediaUploader


end
