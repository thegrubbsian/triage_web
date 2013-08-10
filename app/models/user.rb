class User < ActiveRecord::Base

  has_many :tasks

  attr_accessor :password, :password_confirmation

  scope :by_email, ->(email) { where(email: email) }

  def self.find_by_auth_key(auth_key)
    User.where(auth_key: auth_key).first || NullUser.new
  end

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validate :name, presence: true
  validate :email, presence: true, uniqueness: true

  before_save :encrypt_password

  def authorized
    true
  end

  private

  def encrypt_password
    return unless password.present?
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

end
