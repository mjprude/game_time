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
    if params[:user_won] == "true"
      current_user.hangman_wins += 1
      current_user.hangmen.last.delete
      current_user.save!
    elsif params[:user_won] == "false"
      current_user.hangman_losses += 1
      current_user.hangmen.last.delete
      current_user.save!
    else
      redirect '/hangman'
    end
    {}.to_json
  end

  # get '/hangman/:guess' do
  #   authenticate!
  #   content_type :json
  #   game = current_user.hangmen[0]
  #   game.guess(params[:guess])
  #   game.data
  # end

end