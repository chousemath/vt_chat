class Room < ApplicationRecord
  before_save :default_values

  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  has_many :room_users, dependent: :destroy

  validates :name, presence: true

  enum room_type: %i[open closed]

  def default_values
    self.video_url = "https://appr.tc/r/#{SecureRandom.hex(15)}" if !self.video_url && self.room_type == 'closed'
    self.room_type ||= 'open'
  end
end
