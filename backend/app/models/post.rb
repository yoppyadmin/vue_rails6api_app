class Post < ApplicationRecord
  belongs_to :user
  has_one :quantity, dependent: :destroy
  has_many :votes, dependent: :destroy
end
