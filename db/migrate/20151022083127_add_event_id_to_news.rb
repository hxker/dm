class AddEventIdToNews < ActiveRecord::Migration
  def change
    add_column :news, :event_id, :integer
    add_index :news, :event_id
  end
end
