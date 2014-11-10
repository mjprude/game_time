class Ttt < ActiveRecord::Base
  has_many :ttt_games
  has_many :users, through: :ttt_games

  def make_move
    winning_combos = [0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]
    winning_combos.each do |combo|
      line = combo.map {|i| self.game_state[i]}
      if line == ["X","X","X"]
        self.update(game_over: true)
        return "X"
      elsif line == ["O","O","O"]
        self.update(game_over: true)
        return "O"
      end
    end
  end

  def active_player
    self.ttt_games.find_by(turn: true)
  end

  def swap_players
    next_player = self.ttt_games.find_by(turn: false)
    self.active_player.update(turn: false)
    next_player.update(turn: true)
    next_player.user_sym
  end

end