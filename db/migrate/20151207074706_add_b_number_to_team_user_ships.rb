class AddBNumberToTeamUserShips < ActiveRecord::Migration
  def change
    add_column :team_user_ships, :b_number, :string
  end
end
