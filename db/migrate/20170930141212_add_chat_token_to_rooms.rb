class AddChatTokenToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :video_token, :jsonb
  end
end
