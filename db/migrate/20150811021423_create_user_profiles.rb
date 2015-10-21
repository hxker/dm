class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :username
      t.integer :gender
      t.integer :age
      t.string :school
      t.string :grade
      t.string :bj # 班级
      t.string :autograph # 个性签名
      t.string :address
      t.date :birthday
      t.string :address

      t.timestamps
    end

    add_index :user_profiles, :user_id, unique: true
    add_index :user_profiles, :school
    add_index :user_profiles, :gender
  end
end
