require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'show /rooms/:id' do
    context 'success cases' do
      it 'should create a new RoomUser if user visits room for first time' do
        room_user_count_before = RoomUser.count
        user = User.create(email: 'user3@vtchat.com', password: 'password')
        last_room = Room.last
        sign_in user
        get :show, params: {
          id: last_room.id
        }
        room_user_count_after = RoomUser.count
        expect(room_user_count_after).to eq(room_user_count_before + 1)
        last_room_user = RoomUser.last
        expect(last_room_user.user).to eq(user)
        expect(last_room_user.room).to eq(last_room)
        expect(last_room_user.role).to eq('guest')
        get :show, params: {
          id: last_room.id
        }
        expect(RoomUser.count).to eq(room_user_count_after)
      end
    end
  end

  describe 'post /rooms' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        room_count_before = User.count
        post :create, params: {
          room: {
            # name: 'aldkjfalskdfjalsdf',
            video_url: 'http://guides.rubyonrails.org'
          }
        }
        expect(Room.count).to eq(room_count_before)
      end

      it 'should reject a request without a room name' do
        room_count_before = Room.count
        user = User.all.sample
        sign_in user
        post :create, params: {
          room: {
            # name: 'aldkjfalskdfjalsdf',
            video_url: 'http://guides.rubyonrails.org'
          }
        }
        # expect(response).to be_successful
        expect(response).to render_template(:new)
        expect(Room.count).to eq(room_count_before)
      end
    end

    context 'success cases' do
      it 'should create a room if logged in, all attributes present' do
        room_count_before = Room.count
        room_user_count_before = RoomUser.count
        user = User.all.sample
        sign_in user
        post :create, params: {
          room: {
            name: 'aldkjfalskdfjalsdf',
            video_url: 'http://guides.rubyonrails.org',
            video_token: 'alsdkfjasldkfj'
          }
        }
        expect(Room.count).to eq(room_count_before + 1)
        last_room = Room.last
        expect(last_room.name).to eq('aldkjfalskdfjalsdf')
        expect(last_room.video_url).to eq('http://guides.rubyonrails.org')
        expect(last_room.video_token).to eq('alsdkfjasldkfj')
        expect(RoomUser.count).to eq(room_user_count_before + 1)
        last_room_user = RoomUser.last
        expect(last_room_user.user).to eq(user)
        expect(last_room_user.room).to eq(last_room)
        expect(last_room_user.role).to eq('owner')
      end
    end
  end
end
