class User < ApplicationRecord
  before_save ->{email.downcase!}
  validates :name, presence: true,
                   length: {maximum: Settings.user.name.max_length}
  validates :email, presence: true,
                    length: {maximum: Settings.user.email.max_length},
                    format: {with: Settings.user.email.regex},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true,
                       length: {minimum: Settings.user.password.min_length}
  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt:: Engine::MIN_COST
            else
              BCrypt:: Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end
end
