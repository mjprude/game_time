class User < ActiveRecord::Base
  validates :username, uniqueness: true
  include BCrypt
  def password
    Password.new(self.password_hash)
  end

  def password=(new_password)
    self.password_hash = Password.create(new_password)
  end
end