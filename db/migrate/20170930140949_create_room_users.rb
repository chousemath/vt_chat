class CreateRoomUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :room_users do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
