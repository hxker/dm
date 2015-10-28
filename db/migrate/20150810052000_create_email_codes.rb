class CreateEmailCodes < ActiveRecord::Migration
  def change
    create_table :email_codes do |t|
      t.string :email, limit: 20
      t.string :code, limit: 20
      t.string :message_type, limit: 20
      t.integer :failed_attempts
      t.string :ip, limit: 50

      t.timestamps
    end

    add_index :email_codes, :email
    add_index :email_codes, :message_type
    add_index :email_codes, :ip
  end
end
