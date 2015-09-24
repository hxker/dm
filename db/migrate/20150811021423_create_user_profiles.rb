class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :username
      t.integer :gender
      t.integer :age
      t.string :school
      t.string :grade
      t.string :address
      t.date :birthday
      t.string :address

      t.timestamps
    end

    add_index :user_profiles, :user_id, unique: true
  end
end
