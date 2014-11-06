class User < ActiveRecord::Base
  has_many :hangmen
  validates :username, uniqueness: true
  include BCrypt
  def password
    Password.new(self.password_hash)
  end

  def password=(new_password)
    self.password_hash = Password.create(new_password)
  end
end