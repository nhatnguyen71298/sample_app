class User < ApplicationRecord
  attr_accessor :remember_token

  has_secure_password

  validates :name, presence: true,
                   length: {maximum: Settings.user.name.max_length}
  validates :email, presence: true,
                    length: {maximum: Settings.user.email.max_length},
                    format: {with: Settings.user.email.regex},
                    uniqueness: true
  validates :password, presence: true,
                       length: {minimum: Settings.user.password.min_length},
                       allow_nil: Settings.user.allow_nil

  before_save ->{email.downcase!}

  scope :ordered_by_name_desc, ->{order(name: :desc)}

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt:: Engine::MIN_COST
            else
              BCrypt:: Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end
end
