class Schedule < ActiveRecord::Base
  has_many :scores
  validates :name, presence: true, uniqueness: true
end
