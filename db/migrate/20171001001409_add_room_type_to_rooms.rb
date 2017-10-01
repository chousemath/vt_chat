class AddRoomTypeToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :room_type, :integer
  end
end
