class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  validate :password, length: { minimum: 6, has_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
    reuturn nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def generate_session_token
    SecureRandom.urlsafe_base64
  end

  def reset_session_token
    self.session_token = generate_session_token
    self.save
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
  BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
