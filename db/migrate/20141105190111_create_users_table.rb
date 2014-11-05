class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_hash
      t.string :avatar
      t.string :age
      t.integer :hangman_score, default: 0
      t.integer :ttt_score, default: 0
      t.timestamps
    end
  end
end
