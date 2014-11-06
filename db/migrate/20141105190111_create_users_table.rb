class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_hash
      t.string :avatar
      t.string :age
      t.integer :hangman_wins, default: 0
      t.integer :hangman_losses, default: 0
      t.integer :ttt_wins, default: 0
      t.integer :ttt_losses, default: 0
      t.timestamps
    end
  end
end
