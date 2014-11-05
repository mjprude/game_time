require 'bundler'
Bundler.require

require 'sinatra/activerecord/rake'
require './connection'
Dir.glob('./{lib,helpers,controllers}/*.rb').each do |file|
  require file
  puts "required #{file}"
end

namespace :db do

  desc "Create Games Database"
  task :create_db do
    conn = PG::Connection.open()
    conn.exec('CREATE DATABASE games_db;')
    conn.close
  end

end