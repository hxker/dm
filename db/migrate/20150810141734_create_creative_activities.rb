class CreateCreativeActivities < ActiveRecord::Migration
  def change
    create_table :creative_activities do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :cover
      t.string :like_num


      t.timestamps
    end
    add_index :creative_activities, :user_id
    add_index :creative_activities, :name
  end
end
