class Competition < ActiveRecord::Base
  belongs_to :organizer
  has_many :events

  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  validates :organizer_units, presence: true
  # validates :apply_end_time, presence: true
  # validates :apply_end_time, presence: true
  # validates :start_time, presence: true
  # validates :end_time, presence: true
  validates :status, presence: true
  validate :validate_datetime
  validate :validate_organizer
  STATUS = {
      接受报名: 0,
      报名截止: 1,
      比赛结束: 2,
  }

  def validate_organizer
    if organizer_units.present? and help_units.present?
      if (organizer_units.split(',') & help_units.split(',')).count > 0
        errors[:organizer_units] << '同一单位不能同时出现在协办方和主办方中'
      end
    end
  end

  def validate_datetime
    if apply_start_time.present? and apply_end_time.present? and start_time.present? and end_time.present?
      if apply_end_time < apply_start_time
        errors[:apply_start_time] << '报名结束时间不能早于报名开始时间'
      end
      if start_time < apply_end_time
        errors[:start_time] << '比赛开始时间不能早于报名结束时间'
      end
      if start_time > end_time
        errors[:end_time] << '比赛结束时间不能早于比赛开始时间'
      end
    else
      errors[:end_time] << '比赛报名起始时间和比赛起始时间为必填项'
    end

  end

end
