class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, limit:50 #赛事名称
      t.string :organizers, limit:50 #发布人
      t.string :desc, limit:500 #赛事描述
      t.integer :state #赛事状态
      t.integer :sort #赛事排序字段
      t.datetime :sign_in_begin_time #报名开始时间
      t.datetime :sign_in_end_time #报名截止时间
      t.datetime :begin_time #赛事举办开始时间
      t.datetime :end_time #赛事结束时间

      t.timestamps
    end
  end
end
