class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  has_many :room_users, dependent: :destroy

  validates :name, presence: true
end
