class RoomUser < ApplicationRecord
  before_save :default_values

  belongs_to :user
  belongs_to :room

  enum role: %i[guest owner]

  validates :room_id, presence: true
  validates :user_id, presence: true

  def default_values
    self.role ||= 'guest'
  end
end
