class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :creative_activity_id
      t.integer :user_id
      t.datetime :created_at

    end

    add_index :likes, [:creative_activity_id, :user_id], unique: true

  end
end
