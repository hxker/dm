class District < ActiveRecord::Base
  has_many :teams, foreign_key: :district
  validates :name, presence: true, uniqueness: true
end
