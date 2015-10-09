class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :cover
      t.integer :user_id # 队长
      t.string :description # 队伍介绍
      t.string :teacher # 指导教师
      t.integer :event_id
      t.string :team_code, limit: 6

      t.timestamps
    end

    add_index :teams, :name
    add_index :teams, :event_id
    add_index :teams, :team_code
    add_index :teams, :user_id
    add_index :teams, :teacher

  end
end