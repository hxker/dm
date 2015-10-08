class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :competition_id
      t.text :description
      t.string :cover
      t.integer :status
      t.integer :team_min_num
      t.integer :team_max_num
      t.datetime :apply_start_time
      t.datetime :apply_end_time
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
    add_index :events, :name
    add_index :events, :competition_id
    add_index :events, :status
    add_index :events, :apply_end_time
    add_index :events, :apply_start_time
    add_index :events, :team_max_num
    add_index :events, :end_time

  end
end
