class CreateTeamUserShips < ActiveRecord::Migration
  def change
    create_table :team_user_ships do |t|
      t.integer :team_id
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end

    add_index :team_user_ships, :team_id
    add_index :team_user_ships, :user_id
    add_index :team_user_ships, :event_id
    add_index :team_user_ships, [:team_id, :user_id], unique: true
    add_index :team_user_ships, [:event_id, :user_id], unique: true
    add_index :team_user_ships, [:event_id, :team_id]
  end
end
