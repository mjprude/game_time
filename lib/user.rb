class User < ActiveRecord::Base
  has_many :hangmen
  has_many :ttt_games
  has_many :ttts, through: :ttt_games
  validates :username, uniqueness: true
  include BCrypt
  def password
    Password.new(self.password_hash)
  end

  def password=(new_password)
    self.password_hash = Password.create(new_password)
  end
end