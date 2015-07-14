class CreateMobileCodes < ActiveRecord::Migration
  def change
    create_table :mobile_codes do |t|
      t.string :mobile, limit: 20
      t.string :code, limit: 20
      t.string :message_type, limit: 20
      t.integer :failed_attempts
      t.string :ip, limit: 50

      t.timestamps
    end

    add_index :mobile_codes, :mobile
    add_index :mobile_codes, :message_type
    add_index :mobile_codes, :ip
  end
end