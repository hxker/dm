class CreateNewsTypes < ActiveRecord::Migration
  def change
    create_table :news_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :news_types, :name, unique: true
  end
end
