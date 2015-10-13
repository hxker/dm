class Organizer < ActiveRecord::Base
  has_many :competitions

  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  validates :category, presence: true

  CATEGORY = {other: 1, support: 2, undertake: 3}
end
