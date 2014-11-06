class ApplicationController < Sinatra::Base
  helpers Sinatra::AuthenticationHelper
  helpers Sinatra::LinkHelper
  helpers Sinatra::LetterHelper

  before do
    @connection = ActiveRecord::Base.establish_connection({adapter: 'postgresql', database: 'games_db'})
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
    game = current_user.hangmen[0]
    game ||= Hangman.create(user: current_user)


  end

  get '/hangman/:guess' do

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