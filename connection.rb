ActiveRecord::Base.establish_connection(
  ENV['DATABASE_URL'] ||
  {
  adapter: 'postgresql',
  database: 'games_db'
  })