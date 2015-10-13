class Event < ActiveRecord::Base
  belongs_to :competition
  has_many :teams
  has_many :scores
  has_many :team_user_ships, through: :teams
  has_many :creative_activities

  validates :name, presence: true
  validates :competition_id, presence: true
  validates :status, presence: true
  validates :team_min_num, presence: true
  validates :team_max_num, presence: true
end
