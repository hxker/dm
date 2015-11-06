class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name

      t.timestamps
    end
    add_index :districts, :name, unique: true
  end
end
