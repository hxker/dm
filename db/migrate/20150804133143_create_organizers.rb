class CreateOrganizers < ActiveRecord::Migration
  def change
    create_table :organizers do |t|
      t.string :name, limit: 50
      t.integer :category
      t.string :responsible
      t.string :tel
      t.string :address

      t.timestamps
    end

    add_index :organizers, :name, unique: true
    add_index :organizers, :category

  end
end
