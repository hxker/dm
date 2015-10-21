class Event < ActiveRecord::Base
  belongs_to :competition
  has_many :teams
  has_many :scores
  has_many :team_user_ships, through: :teams
  has_many :creative_activities
  mount_uploader :cover, EventUploader

  validates :name, presence: true
  validates :competition_id, presence: true
  validates :status, presence: true
  validates :team_min_num, presence: true
  validates :team_max_num, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :validate_datetime

  def validate_datetime
    if self.start_time.present? and self.end_time.present?
      if end_time < start_time
        errors[:end_time] << '比赛结束时间不能早于比赛开始时间'
      end
    end
  end
end
