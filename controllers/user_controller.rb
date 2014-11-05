class UsersController < ApplicationController

  get '/' do
    erb :'users/index'
  end

  get '/new' do
    erb :'users/new'
  end

  post '/' do
    user = User.new(params[:user])
    user.password = params[:password]
    user.save!
    redirect "/login"
  end

  get '/:id/edit' do

    erb :'users/edit'
  end

  patch '/:id' do

    redirect "users/#{params[:id]}"
  end

  get '/:id' do
    @user = User.find(params[:id])
    erb :'users/show'
  end

  delete '/:id' do

    redirect '/'
  end

end