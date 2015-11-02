class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :cover
      t.integer :user_id # 队长
      t.integer :group # 组别
      t.string :district # 区县
      t.string :description # 队伍介绍
      t.string :teacher # 指导教师
      t.string :teacher_mobile
      t.string :identifier # 队伍编号
      t.integer :event_id
      t.string :team_code, limit: 6
      t.text :score_process
      t.string :last_score
      t.string :referee_id
      t.integer :rank
      t.text :note

      t.timestamps
    end

    add_index :teams, :name
    add_index :teams, :event_id
    add_index :teams, :team_code
    add_index :teams, :user_id
    add_index :teams, :teacher
    add_index :teams, :district

  end
end
