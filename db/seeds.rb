# require in ruby gem to create fake data
require 'faker'

user_1 = User.create!(
  email: 'user1@vtchat.com',
  password: 'password'
)

user_2 = User.create!(
  email: 'user2@vtchat.com',
  password: 'password'
)

user_3 = User.create!(
  email: 'user3@vtchat.com',
  password: 'password'
)

users = User.all

room_1 = Room.create!(name: 'room1', room_type: 'closed')
RoomUser.create!(room: room_1, user: user_1, role: 'owner')
RoomUser.create!(room: room_1, user: user_2, role: 'guest')

room_2 = Room.create!(name: 'room2', room_type: 'closed')
RoomUser.create!(room: room_2, user: user_2, role: 'owner')
RoomUser.create!(room: room_2, user: user_1, role: 'guest')

rooms = Room.all
room_users = RoomUser.all

rooms.each do |r|
  10.times do
    Message.create!(room: r, user: users.sample, content: Faker::Lorem.sentence)
  end
end

messages = Message.all

puts "#{users.count} users were created"
puts "#{rooms.count} rooms were created"
puts "#{room_users.count} room users were created"
puts "#{messages.count} messages were created"

