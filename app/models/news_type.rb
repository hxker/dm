class NewsType < ActiveRecord::Base
  has_many :news
  validates :name, presence: true, uniqueness: true, length: 1..20
end
