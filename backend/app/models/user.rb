class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validates :name,  presence: true
  validates :email, presence: true
  has_secure_password
  validates :password, presence: true
end
