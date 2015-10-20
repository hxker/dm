class Score < ActiveRecord::Base
  belongs_to :event
  belongs_to :team1, foreign_key: :team1_id, class_name: Team
  belongs_to :team2, foreign_key: :team2_id, class_name: Team
  belongs_to :admin, foreign_key: :operator
  belongs_to :schedule, foreign_key: :comp_name

  KIND = {mark: 1, confrontation: 2}


  validates :team1_id, presence: true
  validates :team2_id, presence: true
  validates :score1, presence: true
  validates :score2, presence: true
  validates :comp_name, presence: true
  validates :kind, presence: true
  before_validation :validate_params

  def validate_params
    if self.kind == 2
      if self.team1_id == self.team2_id
        errors[:team2_id] << '对抗模式下两队伍不能相同'
      end
      if self.score1 != '0' and self.score1 != '1'
        errors[:score1] << '对抗模式下分数只能为1或者0'
      end
      if self.score2 != '0' and self.score2 != '1'
        errors[:score2] << '对抗模式下分数只能为1或者0'
      end
    end
  end
end
