class News < ActiveRecord::Base
  belongs_to :news_type
  belongs_to :admin
  validates :name, presence: true, uniqueness: true, length: {maximum: 60}
  validates :news_type_id, presence: true
  validates :content, presence: true
  validates :admin_id, presence: true
  # after_create :create_uuid

  # def create_uuid
  #   self.content = SecureRandom.uuid
  #   self.save
  # end
end
