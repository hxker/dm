class AddIdentifierToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :identifier, :string
  end
end
