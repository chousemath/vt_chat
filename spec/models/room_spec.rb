require 'rails_helper'

RSpec.describe Room, type: :model do
  it "is valid with valid attributes" do
    room = Room.new(name: 'asldfkjasldkfja')
    expect(room).to be_valid
    room.save!
    last_room = Room.last
    expect(last_room.name).to eq('asldfkjasldkfja')
    expect(last_room.room_type).to eq('open')
  end

  it "is invalid without all valid attributes (name)" do
    expect(Room.new(
      # name: 'asldfkjasldkfja'
    )).not_to be_valid
  end
end
