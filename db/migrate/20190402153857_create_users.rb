class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      t.string :email, unique: true
      t.string :password_digest

      t.integer :role, default: 0

      t.boolean :active, default: true

      t.string :name

      t.timestamps
    end

    add_index :users, :email
  end
end