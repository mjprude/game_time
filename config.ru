require 'bundler'
Bundler.require

Dir.glob('./{lib,helpers,controllers}/*.rb').each do |file|
  require file
  puts "required #{file}"
end

map('/'){ run ApplicationController }
map('/users'){ run UsersController }
map('/sessions'){ run SessionsController }