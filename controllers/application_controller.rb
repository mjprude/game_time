class ApplicationController < Sinatra::Base

  require '../helpers/authentication_helper'

  helpers Sinatra::AuthenticationHelper
  helpers Sinatra::LinkHelper
  helpers Sinatra::LetterHelper

  before do
    @connection = ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || {adapter: 'postgresql', database: 'games_db'})
  end
  after do
    @connection.disconnect!
  end

  enable :sessions, :method_override
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path(File.dirname(__FILE__) + '../../public')

  # ******** routes *********
  get '/' do
    erb :index
  end

  get '/hangman' do
    authenticate!
    erb :hangman
  end

  get '/tictactoe' do
    authenticate!
    @users = User.where.not(id: current_user)
    erb :lobby
  end

  get '/tictactoe/opengames' do
    authenticate!
    @games = current_user.ttts.where(game_over: false)
    erb :'ttt/opengames'
  end

  get '/tictactoe/:id' do
    authenticate!
    ttt = Ttt.find(params[:id])
    @my_sym = ttt.ttt_games.find_by(user: current_user).user_sym
    @their_sym = @my_sym == "X" ? "O" : "X"
    erb :tictactoe
  end

  get '/console' do
    binding.pry
  end
  get '/login' do
    erb :'sessions/new'
  end

  get '/login/failed' do
    erb :'sessions/failed'
  end
end