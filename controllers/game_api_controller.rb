class GameAPIController < ApplicationController

  get '/hangman' do
    authenticate!
    content_type :json
    game = Hangman.where(user: current_user).first_or_create!
    game.guess(params[:guess]) if params[:guess]
    game.data
  end

  post '/hangman' do
    authenticate!
    content_type :json
    game = current_user.hangmen.last
    if params[:user_won] == "true"
      current_user.hangman_wins += 1
      game.delete
      current_user.save!
    elsif params[:user_won] == "false"
      current_user.hangman_losses += 1
      game.delete
      current_user.save!
    else
      redirect '/hangman'
    end
    {word: game.word}.to_json
  end

  post '/ttt/new' do
    game = Ttt.create
    first = false
    second = false
    if params[:sym] == "X" || params[:sym] == nil
      first = true
      next_sym = "O"
    else
      second = true
      next_sym = "X"
    end

    TttGame.create(user: current_user, user_sym: params[:sym], ttt: game, turn: first)
    next_sym = params[:sym] == "X" ? "O" : "X"
    user2 = User.find_by(username: params[:user2])
    TttGame.create(user: user2, user_sym: next_sym, ttt: game, turn: second)
    redirect "/tictactoe/#{game.id}"
  end

  patch '/ttt/:id' do
    content_type :json
    ajaxHash = {}
    game = Ttt.find(params[:id])
    if game.game_state != params[:game_state]
      binding.pry
      game.make_move
      game.update(game_state: params[:game_state])
      game.save!
    end
    winning_sym = game.make_move
    if game.game_over
      win_game = game.ttt_games.find_by(user_sym: winning_sym)
      win_user = User.find(win_game.user_id)
      win_user.ttt_wins += 1
      win_user.save!
      win_game.delete
      lose_game = game.ttt_games.first
      loser = User.find(lose_game.user_id)
      loser.ttt_losses += 1
      loser.save!
      lose_game.delete
      ajaxHash[:winner] = win_user.username
    end
    ajaxHash[:game_state] = game.game_state
    game.swap_players
    ajaxHash[:turn] = game.current_player.user_sym
    ajaxHash.to_json
  end

  get '/ttt/:id' do
    content_type :json
    ajaxHash = {}
    game = Ttt.find(params[:id])
    ajaxHash[:game_state] = game.game_state
    ajaxHash[:winner] = win_user.username if game.game_over
    ajaxHash[:turn] = game.current_player.user_sym
  end

end


