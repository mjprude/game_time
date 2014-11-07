class SessionsController < ApplicationController

  post '/' do
    if !user = User.find_by({username: params[:username]})
      redirect '/login/failed'
    elsif user.password == params[:password]
      session[:current_user] = user.id
      redirect "/hangman"
    else
      redirect '/login/failed'
    end
  end

  delete '/' do
    session[:current_user] = nil
    redirect '/'
  end

end