require 'rails_helper'

RSpec.describe RoomUser, type: :model do
  it "is valid with valid attributes" do
    u = User.create(email: 'alsdkfjalsdf@gmail.com', password: 'password')
    r = Room.create(name: 'asdhfajsdhfjsdhfjdsdfsdfsdfsdfsdf')
    expect(RoomUser.new(
      user_id: u.id,
      room_id: r.id
    )).to be_valid
  end

  it "is invalid without all valid attributes (user_id)" do
    r = Room.create(name: 'asdhdfdfdfdfdfdffajsdhfjsdhfjdsdfsdfsdfsdfsdf')
    expect(RoomUser.new(
      # user_id: u.id,
      room_id: r.id
    )).not_to be_valid
  end

  it "is invalid without all valid attributes (room_id)" do
    u = User.create(email: 'alsdkfjaldfdsdf@gmail.com', password: 'password')
    expect(RoomUser.new(
      user_id: u.id
      # room_id: r.id
    )).not_to be_valid
  end
end
