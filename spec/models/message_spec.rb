require 'rails_helper'

RSpec.describe Message, type: :model do
  it "is valid with valid attributes" do
    expect(Message.new(
      content: 'asldfkjasldkfja',
      room_id: Room.last.id,
      user_id: User.last.id
    )).to be_valid
  end

  it "is invalid without all valid attributes (content)" do
    expect(Message.new(
      # content: 'asldfkjasldkfja',
      room_id: Room.last.id,
      user_id: User.last.id
    )).not_to be_valid
  end

  it "is invalid without all valid attributes (room_id)" do
    expect(Message.new(
      content: 'asldfkjasldkfja',
      # room_id: Room.last.id
      user_id: User.last.id
    )).not_to be_valid
  end

  it "is invalid without all valid attributes (user_id)" do
    expect(Message.new(
      content: 'asldfkjasldkfja',
      room_id: Room.last.id
      # user_id: User.last.id
    )).not_to be_valid
  end
end
