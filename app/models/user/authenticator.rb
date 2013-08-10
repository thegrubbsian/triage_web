class User::Authenticator

  def self.authenticate(email, password)
    user = User.by_email(email).first
    return nil unless user
    hashed_password = BCrypt::Engine.hash_secret(password, user.password_salt)
    return nil unless user.password_hash == hashed_password
    issue_auth_key!(user)
    user
  end

  def self.sign_up(attrs)
    user = User.new(attrs)
    issue_auth_key!(user)
    return user if user.save
    return nil
  end

  def self.issue_auth_key!(user)
    user.auth_key = "#{SecureRandom.uuid}-#{SecureRandom.hex(3)}"
    user.save
  end

end
