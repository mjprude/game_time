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
    authenticate!
    @user = User.find(params[:id])
    erb :'users/edit'
  end

  patch '/:id' do
    authenticate!
    user = User.find(params[:id])
    if params[:password]
      user.password = params[:password]
      user.save!
    end
    user.update(username: params[:user][:username]) unless params[:user][:username] = ""
    user.update(age: params[:user][:age]) unless params[:user][:age] = ""
    redirect "users/#{params[:id]}"
  end

  get '/:id' do
    authenticate!
    @user = User.find(params[:id])
    erb :'users/show'
  end

  delete '/:id' do
    authenticate!
    User.destroy(params[:id])
    session[:current_user] = nil
    redirect '/'
  end

end