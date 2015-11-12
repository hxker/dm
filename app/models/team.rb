class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :district
  has_many :team_user_ships, foreign_key: :team_id
  has_many :users, through: :team_user_ship
  has_many :scores
  GROUP = {primary: 1, middle: 2}

  # validates :name, presence: true, length: {in: 2..6}
  # validates :user_id, presence: true
  # validates :event_id, presence: true
  # validates :teacher, presence: true
  # validates :team_code, length: {in: 4..6}
  # validates_uniqueness_of :event_id, :scope => :user_id
  # validates_uniqueness_of :event_id, :scope => :name

  mount_uploader :cover, CoverUploader
end