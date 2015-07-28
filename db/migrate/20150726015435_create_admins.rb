class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :job_number, limit: 50
      t.string :password_digest
      t.string :name, limit: 50
      t.string :permissions, limit: 50
      t.string :position, limit: 50
      t.integer :age
      t.integer :gender
      t.string :email, limit: 50
      t.string :phone, limit: 50
      t.string :address
      t.integer :sign_in_count
      t.datetime :current_sign_in_at
      t.string :current_sign_in_ip, limit: 50
      t.datetime :last_sign_in_at
      t.string :last_sign_in_ip, limit: 50
      t.integer :failed_attempts
      t.datetime :locked_at
      t.string :access_token
      t.datetime :last_activity_at


      t.timestamps
    end
    add_index :admins, :job_number, unique: true
    add_index :admins, :name
    add_index :admins, :access_token

  end
end
