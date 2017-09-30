require 'rails_helper'

RSpec.describe Room, type: :model do
  it "is valid with valid attributes" do
    expect(Room.new(
      name: 'asldfkjasldkfja'
    )).to be_valid
  end

  it "is invalid without all valid attributes (name)" do
    expect(Room.new(
      # name: 'asldfkjasldkfja'
    )).not_to be_valid
  end
end
