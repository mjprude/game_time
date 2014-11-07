class CreateHangmanTable < ActiveRecord::Migration
  def change
    create_table :hangmen do |t|
      t.string :word
      t.string :latlng
      t.string :game_state
      t.string :bad_guesses, default: ""
      t.references :user
      t.timestamps
    end
  end
end
