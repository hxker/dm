class CreateCreativeActivities < ActiveRecord::Migration
  def change
    create_table :creative_activities do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :is_audit, default: 0, null: false # 0 待审核 1 通过 2 未通过
      t.string :name
      t.text :description
      t.string :cover
      t.string :file
      t.string :media
      t.integer :likes_count, default: 0
      t.string :expert_score
      t.string :last_score


      t.timestamps
    end
    add_index :creative_activities, :user_id
    add_index :creative_activities, :name
    add_index :creative_activities, :event_id
    add_index :creative_activities, :is_audit
  end
end
