class User < ApplicationRecord
  has_one :account, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォローする人
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォローされる人
  # has_many :following, through: :follower, source: :followed # フォローする人の集合
  # has_many :followers, through: :followed, source: :follower # フォローされる人の集合

  attr_accessor :remember_token

  mount_uploader :avatar, AvatarUploader
  validates :name,  presence: true
  validates :email, presence: true
  has_secure_password
  validates :password, presence: true,
                       allow_nil: true

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
