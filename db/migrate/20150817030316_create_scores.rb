class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :event_id
      t.integer :comp_name # eg.预赛/决赛
      t.integer :kind # 评分/对抗
      t.integer :th # 第几场
      t.integer :team1_id
      t.integer :team2_id
      t.string :score1
      t.string :score2
      t.integer :referee_id # 主裁判
      t.integer :operator # 成绩录入员


      t.timestamps
    end
    add_index :scores, :event_id
    add_index :scores, :comp_name
    add_index :scores, :kind
    add_index :scores, :team1_id
    add_index :scores, :team2_id
    add_index :scores, :referee_id
    add_index :scores, :operator
  end
end
