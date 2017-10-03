require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'failure cases' do
    it 'is invalid without all valid attributes (name)' do
      expect(Room.new(
        # name: 'asldfkjasldkfja'
      )).not_to be_valid
    end
  end

  context 'success cases' do
    it 'is valid with valid attributes' do
      room = Room.new(name: 'asldfkjasldkfja')
      expect(room).to be_valid
      room.save!
      last_room = Room.last
      expect(last_room.name).to eq('asldfkjasldkfja')
      expect(last_room.room_type).to eq('open')
    end

    it 'generates a video_url automatically if room type is closed' do
      room = Room.new(name: 'i234jkjsdf', room_type: 'closed')
      expect(room).to be_valid
      room.save!
      last_room = Room.last
      expect(last_room.name).to eq('i234jkjsdf')
      expect(last_room.room_type).to eq('closed')
      expect(last_room.video_url).not_to be_nil
    end
  end
end
