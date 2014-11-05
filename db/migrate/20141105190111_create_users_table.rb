class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_hash
      t.string :avatar
      t.string :age
      t.string :hangman_score
      t.string :ttt_score
      t.timestamps
    end
  end
end
