class User < ActiveRecord::Base
  include BCrypt
  def password
    Password.new(self.password_hash)
  end

  def password=(new_password)
    self.password_hash = Password.create(new_password)
  end
end