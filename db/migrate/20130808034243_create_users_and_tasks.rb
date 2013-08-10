class CreateUsersAndTasks < ActiveRecord::Migration

  def change

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :auth_key
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :auth_key, unique: true

    create_table :tasks do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :state, null: false
      t.text :description
      t.date :due_at
      t.timestamps
    end
    add_index :tasks, :user_id

  end

end
