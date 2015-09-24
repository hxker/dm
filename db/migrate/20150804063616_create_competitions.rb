class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, null: false
      t.string :guide_units # 指导单位
      t.string :organizer_units # 主办单位
      t.string :help_units # 协办单位
      t.string :support_units # 赞助商
      t.string :undertake_units # 承办单位
      t.text :description
      t.string :cover
      t.text :video
      t.text :file
      t.integer :status
      t.integer :team_min_num
      t.integer :team_max_num
      t.datetime :apply_start_time
      t.datetime :apply_end_time
      t.datetime :start_time
      t.datetime :end_time
      t.string :keyword


      t.timestamps
    end

    add_index :competitions, :name, unique: true
    add_index :competitions, :status
    add_index :competitions, :start_time
    add_index :competitions, :end_time


  end
end
