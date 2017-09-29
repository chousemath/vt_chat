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

users = User.all

room_1 = Room.create!(name: 'room1', video_url: 'https://github.com')

room_2 = Room.create!(name: 'room2', video_url: 'https://github.com')

rooms = Room.all

rooms.each do |r|
  10.times do
    Message.create!(room: r, user: users.sample, content: Faker::Lorem.sentence)
  end
end

messages = Message.all

puts "#{users.count} users were created"
puts "#{rooms.count} rooms were created"
puts "#{messages.count} messages were created"

