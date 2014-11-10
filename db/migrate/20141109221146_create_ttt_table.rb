class CreateTttTable < ActiveRecord::Migration
  def change
    create_table :ttts do |t|
      t.boolean :game_over, default: false
      t.string :game_state, default: '         '
      t.timestamps
    end
  end
end
