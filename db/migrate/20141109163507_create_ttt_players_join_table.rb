class CreateTttPlayersJoinTable < ActiveRecord::Migration
  def change
    create_table :ttt_games do |t|
      t.references :user
      t.string :user_sym
      t.references :ttt
      t.boolean :turn, default: false
      t.timestamps
    end
  end
end